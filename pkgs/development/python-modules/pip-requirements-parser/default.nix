{ lib
, buildPythonPackage
, fetchFromGitHub
, packaging
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pip-requirements-parser";
  version = "31.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i4hw3tS4i2ek2JzcDiGo5aFFJ9J2JJ9MB5vxDhOilb0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    packaging
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pip_requirements_parser"
  ];

  meta = with lib; {
    description = "Module to parse pip requirements";
    homepage = "https://github.com/nexB/pip-requirements-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
