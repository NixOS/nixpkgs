{ stdenv, fetchurl, libGLU, xlibsWrapper, libXmu, libXi
, AGL ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "glew-1.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/glew/${name}.tgz";
    sha256 = "01zki46dr5khzlyywr3cg615bcal32dazfazkf360s1znqh17i4r";
  };

  buildInputs = [ xlibsWrapper libXmu libXi ]
              ++ optionals stdenv.isDarwin [ AGL ];
  propagatedBuildInputs = [ libGLU ]; # GL/glew.h includes GL/glu.h

  patchPhase = ''
    sed -i 's|lib64|lib|' config/Makefile.linux
    ${optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed -i -e 's/\(INSTALL.*\)-s/\1/' Makefile
    ''}
  '';

  buildFlags = [ "all" ];
  installFlags = [ "install.all" ];

  preInstall = ''
    export GLEW_DEST="$out"
  '';

  postInstall = ''
    mkdir -pv $out/share/doc/glew
    mkdir -p $out/lib/pkgconfig
    cp glew*.pc $out/lib/pkgconfig
    cp -r README.txt LICENSE.txt doc $out/share/doc/glew
  '';

  makeFlags = [
    "SYSTEM=${if stdenv.hostPlatform.isMinGW then "mingw" else stdenv.hostPlatform.parsed.kernel.name}"
  ];

  meta = with stdenv.lib; {
    description = "An OpenGL extension loading library for C(++)";
    homepage = http://glew.sourceforge.net/;
    license = licenses.free; # different files under different licenses
      #["BSD" "GLX" "SGI-B" "GPL2"]
    platforms = platforms.mesaPlatforms;
  };
}
