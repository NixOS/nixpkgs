{ lib, stdenv, fetchFromGitHub, cmake, eigen }:

stdenv.mkDerivation rec {
  pname = "orocos-kdl";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "orocos";
    repo = "orocos_kinematics_dynamics";
    rev = "v${version}";
    sha256 = "15ky7vw461005axx96d0f4zxdnb9dxl3h082igyd68sbdb8r1419";
    # Needed to build Python bindings
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/orocos_kdl";

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
