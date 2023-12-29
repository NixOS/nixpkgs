{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, siobrultech-protocols
}:

buildPythonPackage rec {
  pname = "greeneye-monitor";
  version = "5.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jkeljo";
    repo = "greeneye-monitor";
    rev = "refs/tags/v${version}";
    hash = "sha256-zNGizNOuZuPRdz82y8IaVvwrTos4lZSqTP5FwOlnRao=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    siobrultech-protocols
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "greeneye.monitor"
  ];

  meta = with lib; {
    description = "Receive data packets from GreenEye Monitor";
    homepage = "https://github.com/jkeljo/greeneye-monitor";
    changelog = "https://github.com/jkeljo/greeneye-monitor/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
