{lib, stdenv, fetchurl, libGLU, libGL, freeglut, glew, libXmu, libXext, libX11
, qmake, GLUT, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  version = "1.4.2";
  pname = "opencsg";
  src = fetchurl {
    url = "http://www.opencsg.org/OpenCSG-${version}.tar.gz";
    sha256 = "1ysazynm759gnw1rdhn9xw9nixnzrlzrc462340a6iif79fyqlnr";
  };

  nativeBuildInputs = [ qmake ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ glew ]
    ++ lib.optionals stdenv.isLinux [ libGLU libGL freeglut libXmu libXext libX11 ]
    ++ lib.optional stdenv.isDarwin GLUT;

  doCheck = false;

  patches = [ ./fix-pro-files.patch ];

  preConfigure = ''
    rm example/Makefile src/Makefile
    qmakeFlags=("''${qmakeFlags[@]}" "INSTALLDIR=$out")
  '';

  postInstall = ''
    install -D license.txt "$out/share/doc/opencsg/license.txt"
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/*.app $out/Applications
    rmdir $out/bin || true
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    app=$out/Applications/opencsgexample.app/Contents/MacOS/opencsgexample
    install_name_tool -change \
      $(otool -L $app | awk '/opencsg.+dylib/ { print $1 }') \
      $(otool -D $out/lib/libopencsg.dylib | tail -n 1) \
      $app
  '';

  meta = with lib; {
    description = "Constructive Solid Geometry library";
    homepage = "http://www.opencsg.org/";
    platforms = platforms.unix;
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2;
  };
}

