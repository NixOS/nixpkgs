{
  lib,
  stdenv,
  wrapQtAppsHook,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  ninja,
  pkg-config,
  eigen_3_4_0,
  zlib,
  libpng,
  boost,
  guile,
  python3,
  qtbase,
}:

stdenv.mkDerivation {
  pname = "libfive";
  version = "0-unstable-2025-07-23";

  src = fetchFromGitHub {
    owner = "libfive";
    repo = "libfive";
    rev = "e8370983e7bc6d49409affcc34fc70c673cc876f";
    hash = "sha256-Jtf3yEnIySsLdSt5G3VdU3nUV55LHnES23fCAilXjNw=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    ninja
    pkg-config
    python3.pkgs.pythonImportsCheckHook
  ];
  buildInputs = [
    eigen_3_4_0
    zlib
    libpng
    boost
    guile
    python3
    qtbase
  ];

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
                " $out/${python3.sitePackages}" \

    substituteInPlace libfive/bind/python/libfive/ffi.py \
      --replace "os.path.join('libfive', folder)" \
                "os.path.join('$out/${python3.sitePackages}/libfive', folder)" \

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
      mkdir -p "$out/${python3.sitePackages}/libfive/src"
      ln -s "$out"/lib/libfive.* "$out/${python3.sitePackages}/libfive/src/"
      mkdir -p "$out/${python3.sitePackages}/libfive/stdlib"
      ln -s "$out"/lib/libfive-stdlib.* "$out/${python3.sitePackages}/libfive/stdlib/"

      # Create links so Studio can find the bindings.
      mkdir -p "$out/libfive/bind"
      ln -s "$out/${python3.sitePackages}" "$out/libfive/bind/python"
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
