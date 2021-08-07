{ lib, stdenv, fetchFromGitHub, cmake, eigen }:

stdenv.mkDerivation rec {
  pname = "orocos-kdl";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "orocos";
    repo = "orocos_kinematics_dynamics";
    rev = "v${version}";
    sha256 = "181w2q6lsrfcvrgqwi6m0xrydjlblj1b654apf2d7zjc7qqgd6ca";
    # Needed to build Python bindings
    fetchSubmodules = true;
  };

  sourceRoot = "source/orocos_kdl";

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ eigen ];

  meta = with lib; {
    description = "Kinematics and Dynamics Library";
    homepage = "https://www.orocos.org/kdl.html";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
