{ lib, buildPythonPackage, fetchFromGitHub, humanfriendly, verboselogs, coloredlogs, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "property-manager";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-property-manager";
    rev = version;
    sha256 = "1v7hjm7qxpgk92i477fjhpcnjgp072xgr8jrgmbrxfbsv4cvl486";
  };

  propagatedBuildInputs = [ coloredlogs humanfriendly verboselogs ];
  checkInputs = [ pytest pytestcov ];

  meta = with lib; {
    description = "Useful property variants for Python programming";
    homepage = "https://github.com/xolox/python-property-manager";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
