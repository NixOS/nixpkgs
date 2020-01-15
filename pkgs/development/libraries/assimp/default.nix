{ stdenv, fetchFromGitHub, cmake, boost, zlib }:

stdenv.mkDerivation rec {
  pname = "assimp";
  version = "4.1.0";

  src = fetchFromGitHub{
    owner = "assimp";
    repo = "assimp";
    rev = "v${version}";
    sha256 = "00g61g3ixmfszzjncpvm8x7gp2livaj4lmhbycjmrw4x3gfqlc4r";
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
