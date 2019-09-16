{ lib, buildPythonPackage, fetchFromGitHub, humanfriendly, verboselogs, coloredlogs, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "property-manager";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-property-manager";
    rev = version;
    sha256 = "0s4nwipxd8c2vp4rd8mxrj8wbycniz5ki5n177d0dbrnll5amcz0";
  };

  propagatedBuildInputs = [ coloredlogs humanfriendly verboselogs ];
  checkInputs = [ pytest pytestcov ];

  meta = with lib; {
    description = "Useful property variants for Python programming";
    homepage = https://github.com/xolox/python-property-manager;
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
