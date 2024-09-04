{lib, stdenv, fetchurl, libGLU, libGL, libglut, glew, libXmu, libXext, libX11
, qmake, GLUT, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  version = "1.6.0";
  pname = "opencsg";
  src = fetchurl {
    url = "http://www.opencsg.org/OpenCSG-${version}.tar.gz";
    hash = "sha256-v4+4Dj4M4R2H3XjdFaDehy27iXLYf1+Jz/xGHvrUe+g=";
  };

  nativeBuildInputs = [ qmake ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ glew ]
    ++ lib.optionals stdenv.isLinux [ libGLU libGL libglut libXmu libXext libX11 ]
    ++ lib.optional stdenv.isDarwin GLUT;

  doCheck = false;

  preConfigure = ''
    rm example/Makefile src/Makefile
    qmakeFlags=("''${qmakeFlags[@]}" "INSTALLDIR=$out")
  '';

  postInstall = ''
    install -D copying.txt "$out/share/doc/opencsg/copying.txt"
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/*.app $out/Applications
    rmdir $out/bin || true
  '';

  dontWrapQtApps = true;

  postFixup = lib.optionalString stdenv.isDarwin ''
    app=$out/Applications/opencsgexample.app/Contents/MacOS/opencsgexample
    install_name_tool -change \
      $(otool -L $app | awk '/opencsg.+dylib/ { print $1 }') \
      $(otool -D $out/lib/libopencsg.dylib | tail -n 1) \
      $app
  '';

  meta = with lib; {
    description = "Constructive Solid Geometry library";
    mainProgram = "opencsgexample";
    homepage = "http://www.opencsg.org/";
    platforms = platforms.unix;
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2Plus;
  };
}

