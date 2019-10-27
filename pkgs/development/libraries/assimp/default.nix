{ stdenv, fetchFromGitHub, cmake, boost, zlib }:

stdenv.mkDerivation rec {
  pname = "assimp";
  version = "5.0.0";

  src = fetchFromGitHub{
    owner = "assimp";
    repo = "assimp";
    rev = "v${version}";
    sha256 = "17y5q5hbygmb0cgf96gd3v8sal5g69cp8hmh1cs3yz7v00kjysmz";
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
