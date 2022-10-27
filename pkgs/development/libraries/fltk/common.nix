{ version, rev, sha256 }:

{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, zlib
, libjpeg
, libpng
, fontconfig
, freetype
, libX11
, libXext
, libXinerama
, libXfixes
, libXcursor
, libXft
, libXrender
, ApplicationServices
, Carbon
, Cocoa

, withGL ? true
, libGL
, libGLU
, glew
, OpenGL

, withCairo ? true
, cairo

, withPango ? (lib.strings.versionAtLeast version "1.4" && stdenv.hostPlatform.isLinux)
, pango

, withDocs ? true
, doxygen
, graphviz

, withExamples ? (stdenv.buildPlatform == stdenv.hostPlatform)
, withShared ? true
}:

let
  onOff = value: if value then "ON" else "OFF";
in
stdenv.mkDerivation rec {
  pname = "fltk";
  inherit version;

  src = fetchFromGitHub {
    owner = "fltk";
    repo = "fltk";
    inherit rev sha256;
  };

  outputs = [ "out" ]
    ++ lib.optional withExamples "bin"
    ++ lib.optional withDocs "doc";

  # Manually move example & test binaries to $bin to avoid cyclic dependencies on dev binaries
  outputBin = lib.optionalString withExamples "out";

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./nsosv.patch
  ];

  postPatch = ''
    patchShebangs documentation/make_*
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals withDocs [
    doxygen
    graphviz
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    ApplicationServices
    Carbon
  ] ++ lib.optionals (withGL && !stdenv.hostPlatform.isDarwin) [
    libGL
    libGLU
  ] ++ lib.optionals (withExamples && withGL) [
    glew
  ];

  propagatedBuildInputs = [
    zlib
    libjpeg
    libpng
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    freetype
    fontconfig
    libX11
    libXext
    libXinerama
    libXfixes
    libXcursor
    libXft
    libXrender
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
  ] ++ lib.optionals (withGL && stdenv.hostPlatform.isDarwin) [
    OpenGL
  ] ++ lib.optionals withCairo [
    cairo
  ] ++ lib.optionals withPango [
    pango
  ];

  cmakeFlags = [
    # Common
    "-DOPTION_BUILD_SHARED_LIBS=${onOff withShared}"
    "-DOPTION_USE_SYSTEM_ZLIB=ON"
    "-DOPTION_USE_SYSTEM_LIBJPEG=ON"
    "-DOPTION_USE_SYSTEM_LIBPNG=ON"

    # X11
    "-DOPTION_USE_XINERAMA=${onOff stdenv.hostPlatform.isLinux}"
    "-DOPTION_USE_XFIXES=${onOff stdenv.hostPlatform.isLinux}"
    "-DOPTION_USE_XCURSOR=${onOff stdenv.hostPlatform.isLinux}"
    "-DOPTION_USE_XFT=${onOff stdenv.hostPlatform.isLinux}"
    "-DOPTION_USE_XRENDER=${onOff stdenv.hostPlatform.isLinux}"
    "-DOPTION_USE_XDBE=${onOff stdenv.hostPlatform.isLinux}"

    # GL
    "-DOPTION_USE_GL=${onOff withGL}"
    "-DOpenGL_GL_PREFERENCE=GLVND"

    # Cairo
    "-DOPTION_CAIRO=${onOff withCairo}"
    "-DOPTION_CAIROEXT=${onOff withCairo}"

    # Pango
    "-DOPTION_USE_PANGO=${onOff withPango}"

    # Examples & Tests
    "-DFLTK_BUILD_EXAMPLES=${onOff withExamples}"
    "-DFLTK_BUILD_TEST=${onOff withExamples}"

    # Docs
    "-DOPTION_BUILD_HTML_DOCUMENTATION=${onOff withDocs}"
    "-DOPTION_BUILD_PDF_DOCUMENTATION=OFF"
    "-DOPTION_INSTALL_HTML_DOCUMENTATION=${onOff withDocs}"
    "-DOPTION_INSTALL_PDF_DOCUMENTATION=OFF"
    "-DOPTION_INCLUDE_DRIVER_DOCUMENTATION=${onOff withDocs}"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  preBuild = lib.optionalString (withCairo && withShared && stdenv.hostPlatform.isDarwin) ''
    # unresolved symbols in cairo dylib without this: https://github.com/fltk/fltk/issues/250
    export NIX_LDFLAGS="$NIX_LDFLAGS -undefined dynamic_lookup"
  '';

  postBuild = lib.optionalString withDocs ''
    make docs
  '';

  postInstall = lib.optionalString withExamples ''
    mkdir -p $bin/bin
    mv bin/{test,examples}/* $bin/bin/
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Library/Frameworks
    mv $out{,/Library/Frameworks}/FLTK.framework

    moveAppBundles() {
      echo "Moving and symlinking $1"
      appname="$(basename "$1")"
      binname="$(basename "$(find "$1"/Contents/MacOS/ -type f -executable | head -n1)")"
      curpath="$(dirname "$1")"

      mkdir -p "$curpath"/../Applications/
      mv "$1" "$curpath"/../Applications/
      [ -f "$curpath"/"$binname" ] && rm "$curpath"/"$binname"
      ln -s ../Applications/"$appname"/Contents/MacOS/"$binname" "$curpath"/"$binname"
    }

    rm $out/bin/fluid.icns
    for app in $out/bin/*.app ${lib.optionalString withExamples "$bin/bin/*.app"}; do
      moveAppBundles "$app"
    done
  '';

  postFixup = ''
    substituteInPlace $out/bin/fltk-config \
      --replace "/$out/" "/"
  '';

  meta = with lib; {
    description = "A C++ cross-platform lightweight GUI library";
    homepage = "https://www.fltk.org";
    platforms = platforms.unix;
    # LGPL2 with static linking exception
    # https://www.fltk.org/COPYING.php
    license = licenses.lgpl2Only;
  };
}
