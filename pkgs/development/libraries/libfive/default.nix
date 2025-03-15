{
  lib,
  stdenv,
  wrapQtAppsHook,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
  unstableGitUpdater,
  cmake,
  ninja,
  pkg-config,
  eigen,
  zlib,
  libpng,
  boost,
  guile,
  python,
  qtbase,
  darwin,
}:

stdenv.mkDerivation {
  pname = "libfive";
  version = "0-unstable-2024-10-10";

  src = fetchFromGitHub {
    owner = "libfive";
    repo = "libfive";
    rev = "71899313d36ce14de6646ef760fa6bbc5c0cc067";
    hash = "sha256-bA+4wGAygdbHcOMGFwNyzn2daQ8E7NeOTUF2Tr3RQww=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    ninja
    pkg-config
    python.pkgs.pythonImportsCheckHook
  ];
  buildInputs = [
    # reverts 'eigen: 3.4.0 -> 3.4.0-unstable-2022-05-19'
    # https://github.com/nixos/nixpkgs/commit/d298f046edabc84b56bd788e11eaf7ed72f8171c
    (eigen.overrideAttrs (old: rec {
      version = "3.4.0";
      src = fetchFromGitLab {
        owner = "libeigen";
        repo = "eigen";
        rev = version;
        hash = "sha256-1/4xMetKMDOgZgzz3WMxfHUEpmdAm52RqZvz6i0mLEw=";
      };
      patches = (old.patches or [ ]) ++ [
        # Fixes e.g. onnxruntime on aarch64-darwin:
        # https://hydra.nixos.org/build/248915128/nixlog/1,
        # originally suggested in https://github.com/NixOS/nixpkgs/pull/258392.
        #
        # The patch is from
        # ["Fix vectorized reductions for Eigen::half"](https://gitlab.com/libeigen/eigen/-/merge_requests/699)
        # which is two years old,
        # but Eigen hasn't had a release in two years either:
        # https://gitlab.com/libeigen/eigen/-/issues/2699.
        (fetchpatch {
          url = "https://gitlab.com/libeigen/eigen/-/commit/d0e3791b1a0e2db9edd5f1d1befdb2ac5a40efe0.patch";
          hash = "sha256-8qiNpuYehnoiGiqy0c3Mcb45pwrmc6W4rzCxoLDSvj0=";
        })
      ];
    }))
    zlib
    libpng
    boost
    guile
    python
    qtbase
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk_11_0.frameworks.Cocoa ];

  preConfigure = ''
    substituteInPlace studio/src/guile/interpreter.cpp \
      --replace '"libfive/bind/guile"' \
                '"libfive/bind/guile:${placeholder "out"}/${guile.siteCcacheDir}"' \
      --replace '(app_resource_dir + ":" + finder_build_dir).toLocal8Bit()' \
                '"libfive/bind/guile:${placeholder "out"}/${guile.siteCcacheDir}"'

    substituteInPlace libfive/bind/guile/CMakeLists.txt \
      --replace "LIBFIVE_FRAMEWORK_DIR=$<TARGET_FILE_DIR:libfive>" \
                "LIBFIVE_FRAMEWORK_DIR=$out/lib" \
      --replace "LIBFIVE_STDLIB_DIR=$<TARGET_FILE_DIR:libfive-stdlib>" \
                "LIBFIVE_STDLIB_DIR=$out/lib"

    substituteInPlace libfive/bind/python/CMakeLists.txt \
      --replace ' ''${PYTHON_SITE_PACKAGES_DIR}' \
                " $out/${python.sitePackages}" \

    substituteInPlace libfive/bind/python/libfive/ffi.py \
      --replace "os.path.join('libfive', folder)" \
                "os.path.join('$out/${python.sitePackages}/libfive', folder)" \

    export XDG_CACHE_HOME=$(mktemp -d)/.cache
  '';

  cmakeFlags = [
    "-DGUILE_CCACHE_DIR=${placeholder "out"}/${guile.siteCcacheDir}"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=enum-constexpr-conversion";
  };

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      # No rules to install the mac app, so do it manually.
      mkdir -p $out/Applications
      cp -r studio/Studio.app $out/Applications/Studio.app

      install_name_tool -add_rpath $out/lib $out/Applications/Studio.app/Contents/MacOS/Studio

      makeWrapper $out/Applications/Studio.app/Contents/MacOS/Studio $out/bin/Studio
    ''
    + ''
      # Link "Studio" binary to "libfive-studio" to be more obvious:
      ln -s "$out/bin/Studio" "$out/bin/libfive-studio"

      # Create links since libfive looks for the library in a specific path.
      mkdir -p "$out/${python.sitePackages}/libfive/src"
      ln -s "$out"/lib/libfive.* "$out/${python.sitePackages}/libfive/src/"
      mkdir -p "$out/${python.sitePackages}/libfive/stdlib"
      ln -s "$out"/lib/libfive-stdlib.* "$out/${python.sitePackages}/libfive/stdlib/"

      # Create links so Studio can find the bindings.
      mkdir -p "$out/libfive/bind"
      ln -s "$out/${python.sitePackages}" "$out/libfive/bind/python"
    '';

  pythonImportsCheck = [
    "libfive"
    "libfive.runner"
    "libfive.shape"
    "libfive.stdlib"
  ];

  passthru.updateScript = unstableGitUpdater {
    tagFormat = "";
  };

  meta = with lib; {
    description = "Infrastructure for solid modeling with F-Reps in C, C++, and Guile";
    homepage = "https://libfive.com/";
    maintainers = with maintainers; [
      hodapp
      kovirobi
      wulfsta
    ];
    license = with licenses; [
      mpl20
      gpl2Plus
    ];
    platforms = with platforms; all;
  };
}
