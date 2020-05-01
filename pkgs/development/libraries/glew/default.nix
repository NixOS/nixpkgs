{ stdenv, fetchurl, libGLU, xlibsWrapper, libXmu, libXi
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "glew-2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/glew/${name}.tgz";
    sha256 = "1qak8f7g1iswgswrgkzc7idk7jmqgwrs58fhg2ai007v7j4q5z6l";
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  buildInputs = [ xlibsWrapper libXmu libXi ];
  propagatedBuildInputs = [ libGLU ]; # GL/glew.h includes GL/glu.h

  patchPhase = ''
    sed -i 's|lib64|lib|' config/Makefile.linux
    substituteInPlace config/Makefile.darwin --replace /usr/local "$out"
    ${optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      sed -i -e 's/\(INSTALL.*\)-s/\1/' Makefile
    ''}
  '';

  buildFlags = [ "all" ];
  installFlags = [ "install.all" ];

  preInstall = ''
    makeFlagsArray+=(GLEW_DEST=$out BINDIR=$bin/bin INCDIR=$dev/include/GL)
  '';

  postInstall = ''
    mkdir -pv $out/share/doc/glew
    mkdir -p $out/lib/pkgconfig
    cp glew*.pc $out/lib/pkgconfig
    cp -r README.md LICENSE.txt doc $out/share/doc/glew
    rm $out/lib/*.a
  '';

  makeFlags = [
    "SYSTEM=${if stdenv.hostPlatform.isMinGW then "mingw" else stdenv.hostPlatform.parsed.kernel.name}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An OpenGL extension loading library for C(++)";
    homepage = "http://glew.sourceforge.net/";
    license = licenses.free; # different files under different licenses
      #["BSD" "GLX" "SGI-B" "GPL2"]
    platforms = platforms.mesaPlatforms;
  };
}
