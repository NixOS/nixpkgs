{ lib
, stdenv
, wrapQtAppsHook
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, eigen
, zlib
, libpng
, boost
, guile
, qtbase
, darwin
}:

stdenv.mkDerivation {
  pname = "libfive";
  version = "unstable-2023-06-07";

  src = fetchFromGitHub {
    owner = "libfive";
    repo = "libfive";
    rev = "c85ffe1ba1570c2551434c5bad731884aaf80598";
    hash = "sha256-OITy3fJx+Z6856V3D/KpSQRJztvOdJdqUv1c65wNgCc=";
  };

  nativeBuildInputs = [ wrapQtAppsHook cmake ninja pkg-config ];
  buildInputs = [ eigen zlib libpng boost guile qtbase ]
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

    export XDG_CACHE_HOME=$(mktemp -d)/.cache
  '';

  cmakeFlags = [
    "-DGUILE_CCACHE_DIR=${placeholder "out"}/${guile.siteCcacheDir}"
  ] ++ lib.optionals (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11") [
    # warning: 'aligned_alloc' is only available on macOS 10.15 or newer
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15"
  ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    # No rules to install the mac app, so do it manually.
    mkdir -p $out/Applications
    cp -r studio/Studio.app $out/Applications/Studio.app

    install_name_tool -add_rpath $out/lib $out/Applications/Studio.app/Contents/MacOS/Studio

    makeWrapper $out/Applications/Studio.app/Contents/MacOS/Studio $out/bin/Studio
  '' + ''
    # Link "Studio" binary to "libfive-studio" to be more obvious:
    ln -s "$out/bin/Studio" "$out/bin/libfive-studio"
  '';

  meta = with lib; {
    description = "Infrastructure for solid modeling with F-Reps in C, C++, and Guile";
    homepage = "https://libfive.com/";
    maintainers = with maintainers; [ hodapp kovirobi ];
    license = with licenses; [ mpl20 gpl2Plus ];
    platforms = with platforms; all;
  };
}
