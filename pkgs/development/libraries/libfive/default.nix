{ lib
, mkDerivation
, wrapQtAppsHook
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, eigen
, zlib
, libpng
, boost
, guile_3_0
, stdenv
}:

mkDerivation {
  pname = "libfive-unstable";
  version = "2022-05-19";

  src = fetchFromGitHub {
    owner = "libfive";
    repo = "libfive";
    rev = "d83cc22709ff1f7c478be07ff2419e30e024834e";
    sha256 = "lNJg2LCpFcTewSA00s7omUtzhVxycAXvo6wEM/JjrN0=";
  };

  nativeBuildInputs = [ wrapQtAppsHook cmake ninja pkg-config ];
  buildInputs = [ eigen zlib libpng boost guile_3_0 ];

  preConfigure = ''
    substituteInPlace studio/src/guile/interpreter.cpp \
      --replace "qputenv(\"GUILE_LOAD_COMPILED_PATH\", \"libfive/bind/guile\");" \
                "qputenv(\"GUILE_LOAD_COMPILED_PATH\", \"libfive/bind/guile:$out/lib/guile/3.0/ccache\");"

    substituteInPlace libfive/bind/guile/CMakeLists.txt \
      --replace "LIBFIVE_FRAMEWORK_DIR=$<TARGET_FILE_DIR:libfive>" \
                "LIBFIVE_FRAMEWORK_DIR=$out/lib" \
      --replace "LIBFIVE_STDLIB_DIR=$<TARGET_FILE_DIR:libfive-stdlib>" \
                "LIBFIVE_STDLIB_DIR=$out/lib"

    export XDG_CACHE_HOME=$(mktemp -d)/.cache
  '';

  cmakeFlags = [
    "-DGUILE_CCACHE_DIR=${placeholder "out"}/lib/guile/3.0/ccache"
  ];

  postInstall = if stdenv.isDarwin then ''
    # No rules to install the mac app, so do it manually.
    mkdir -p $out/Applications
    cp -r studio/Studio.app $out/Applications/Studio.app

    install_name_tool \
      -change libfive.dylib $out/lib/libfive.dylib \
      -change libfive-guile.dylib $out/lib/libfive-guile.dylib \
      $out/Applications/Studio.app/Contents/MacOS/Studio
  '' else ''
    # Link "Studio" binary to "libfive-studio" to be more obvious:
    ln -s "$out/bin/Studio" "$out/bin/libfive-studio"
  '';

  meta = with lib; {
    description = "Infrastructure for solid modeling with F-Reps in C, C++, and Guile";
    homepage = "https://libfive.com/";
    maintainers = with maintainers; [ hodapp kovirobi ];
    license = with licenses; [ mpl20 gpl2Plus ];
    platforms = with platforms; linux ++ darwin;
  };
}
