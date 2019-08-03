{stdenv, fetchurl, libGLU_combined, freeglut, glew, libXmu, libXext, libX11
, qmake, GLUT, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  version = "1.4.2";
  name = "opencsg-${version}";
  src = fetchurl {
    url = "http://www.opencsg.org/OpenCSG-${version}.tar.gz";
    sha256 = "1ysazynm759gnw1rdhn9xw9nixnzrlzrc462340a6iif79fyqlnr";
  };

  nativeBuildInputs = [ qmake ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ glew ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libGLU_combined freeglut libXmu libXext libX11 ]
    ++ stdenv.lib.optional stdenv.isDarwin GLUT;

  doCheck = false;

  patches = [ ./fix-pro-files.patch ];

  preConfigure = ''
    rm example/Makefile src/Makefile
    qmakeFlags="$qmakeFlags INSTALLDIR=$out"
  '';

  postInstall = ''
    install -D license.txt "$out/share/doc/opencsg/license.txt"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/*.app $out/Applications
    rmdir $out/bin || true
  '';

  postFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    app=$out/Applications/opencsgexample.app/Contents/MacOS/opencsgexample
    install_name_tool -change \
      $(otool -L $app | awk '/opencsg.+dylib/ { print $1 }') \
      $(otool -D $out/lib/libopencsg.dylib | tail -n 1) \
      $app
  '';

  meta = with stdenv.lib; {
    description = "Constructive Solid Geometry library";
    homepage = http://www.opencsg.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2;
  };
}

