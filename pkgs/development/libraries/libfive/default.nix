{ lib
, stdenv
, wrapQtAppsHook
, fetchFromGitHub
, unstableGitUpdater
, cmake
, ninja
, pkg-config
, eigen
, zlib
, libpng
, boost
, guile
, python
, qtbase
, darwin
}:

stdenv.mkDerivation {
  pname = "libfive";
  version = "0-unstable-2024-06-23";

  src = fetchFromGitHub {
    owner = "libfive";
    repo = "libfive";
    rev = "302553e6aa6ca3cb13b2a149f57b6182ce2406dd";
    hash = "sha256-8J0Pe3lmZCg2YFffmIynxW35w4mHl5cSlLSenm50CWg=";
  };

  nativeBuildInputs = [ wrapQtAppsHook cmake ninja pkg-config python.pkgs.pythonImportsCheckHook ];
  buildInputs = [ eigen zlib libpng boost guile python qtbase ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk_11_0.frameworks.Cocoa ];

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
  ] ++ lib.optionals (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11") [
    # warning: 'aligned_alloc' is only available on macOS 10.15 or newer
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=enum-constexpr-conversion";
  };

  postInstall = lib.optionalString stdenv.isDarwin ''
    # No rules to install the mac app, so do it manually.
    mkdir -p $out/Applications
    cp -r studio/Studio.app $out/Applications/Studio.app

    install_name_tool -add_rpath $out/lib $out/Applications/Studio.app/Contents/MacOS/Studio

    makeWrapper $out/Applications/Studio.app/Contents/MacOS/Studio $out/bin/Studio
  '' + ''
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
    maintainers = with maintainers; [ hodapp kovirobi wulfsta ];
    license = with licenses; [ mpl20 gpl2Plus ];
    platforms = with platforms; all;
  };
}
