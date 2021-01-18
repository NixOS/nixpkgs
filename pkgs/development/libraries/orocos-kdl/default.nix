{ lib, stdenv, fetchFromGitHub, cmake, eigen }:

stdenv.mkDerivation rec {
  pname = "orocos-kdl";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "orocos";
    repo = "orocos_kinematics_dynamics";
    rev = "v${version}";
    sha256 = "0qj56j231h0rnjbglakammxn2lwmhy5f2qa37v1f6pcn81dn13vv";
  };

  sourceRoot = "source/orocos_kdl";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen ];

  meta = with lib; {
    description = "Kinematics and Dynamics Library";
    homepage = "https://www.orocos.org/kdl.html";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
