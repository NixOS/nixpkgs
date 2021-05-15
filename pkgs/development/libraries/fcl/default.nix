{ lib, stdenv, fetchFromGitHub, cmake, eigen, libccd, octomap }:

stdenv.mkDerivation rec {
  pname = "fcl";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "flexible-collision-library";
    repo = pname;
    rev = version;
    sha256 = "1i1sd0fsvk5d529aw8aw29bsmymqgcmj3ci35sz58nzp2wjn0l5d";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ eigen libccd octomap ];

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Flexible Collision Library";
    longDescription = ''
      FCL is a library for performing three types of proximity queries on a
      pair of geometric models composed of triangles.
    '';
    homepage = "https://github.com/flexible-collision-library/fcl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
  };
}
