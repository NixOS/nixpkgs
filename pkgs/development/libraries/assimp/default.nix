{ stdenv, fetchFromGitHub, unzip, cmake, boost, zlib }:

stdenv.mkDerivation rec {
  name = "assimp-${version}";
  version = "3.3.1";

  src = fetchFromGitHub{
    owner = "assimp";
    repo = "assimp";
    rev = "v${version}";
    sha256 = "13y44fymj13h6alig0nqab91j2qch0yh9gq8yql2zz744ch2s5vc";
  };

  buildInputs = [ cmake boost zlib ];

  meta = with stdenv.lib; {
    description = "A library to import various 3D model formats";
    homepage = http://assimp.sourceforge.net/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
