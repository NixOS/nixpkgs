{ stdenv, fetchsvn, cmake, mesa, libX11, freetype, libjpeg, openal, libsndfile
, glew, libXrandr, libXrender
}:
stdenv.mkDerivation rec {
  name = "sfml-svn-${version}";
  version = "1808";
  src = fetchsvn {
    url = "https://sfml.svn.sourceforge.net/svnroot/sfml/branches/sfml2";
    rev = version;
  };
  buildInputs = [ cmake mesa libX11 freetype libjpeg openal libsndfile glew
                  libXrandr libXrender
                ];
  patchPhase = "
    substituteInPlace CMakeLists.txt --replace '\${CMAKE_ROOT}/Modules' 'share/cmake-2.8/Modules'
  ";
  meta = with stdenv.lib; {
    homepage = http://www.sfml-dev.org/;
    description = "A multimedia C++ API that provides access to graphics, input, audio, etc.";
    license = licenses.zlib;
    maintainers = [ maintainers.astsmtl ];
  };
}
