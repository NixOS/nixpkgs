{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  humanfriendly,
  verboselogs,
  coloredlogs,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "property-manager";
  version = "3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-property-manager";
    rev = version;
    sha256 = "1v7hjm7qxpgk92i477fjhpcnjgp072xgr8jrgmbrxfbsv4cvl486";
  };

  propagatedBuildInputs = [
    coloredlogs
    humanfriendly
    verboselogs
  ];
  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Useful property variants for Python programming";
    homepage = "https://github.com/xolox/python-property-manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
}
