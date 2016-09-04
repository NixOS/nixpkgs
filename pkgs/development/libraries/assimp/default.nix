{ stdenv, fetchFromGitHub, unzip, cmake, boost, zlib }:

let
  version = "3.2";
in
stdenv.mkDerivation {
  name = "assimp-${version}";

  src = fetchFromGitHub{
    owner = "assimp";
    repo = "assimp";
    rev = "v${version}";
    sha256 = "09fsksbq9a8gykwmw6gaicwh2ladrln1jc1xc5yk7w6x180cbb1x";
  };

  buildInputs = [ unzip cmake boost zlib ];

  meta = with stdenv.lib; {
    description = "A library to import various 3D model formats";
    homepage = http://assimp.sourceforge.net/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
