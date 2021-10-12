{ lib, stdenv, fetchurl, libGLU, xlibsWrapper, libXmu, libXi
, OpenGL
}:

with lib;

stdenv.mkDerivation rec {
  pname = "glew";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/glew/${pname}-${version}.tgz";
    sha256 = "1qak8f7g1iswgswrgkzc7idk7jmqgwrs58fhg2ai007v7j4q5z6l";
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  buildInputs = optionals (!stdenv.isDarwin) [ xlibsWrapper libXmu libXi ];
  propagatedBuildInputs = if stdenv.isDarwin then [ OpenGL ] else [ libGLU ]; # GL/glew.h includes GL/glu.h

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
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An OpenGL extension loading library for C(++)";
    homepage = "http://glew.sourceforge.net/";
    license = licenses.free; # different files under different licenses
      #["BSD" "GLX" "SGI-B" "GPL2"]
    platforms = platforms.mesaPlatforms;
  };
}
