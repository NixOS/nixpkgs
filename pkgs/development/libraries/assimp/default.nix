{ stdenv, fetchFromGitHub, cmake, boost, zlib }:

stdenv.mkDerivation rec {
  pname = "assimp";
  version = "5.0.1";

  src = fetchFromGitHub{
    owner = "assimp";
    repo = "assimp";
    rev = "v${version}";
    sha256 = "00vxzfcrs856qnyk806wqr67nmpjk06mjby0fqmyhm6i1jj2hg1w";
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
