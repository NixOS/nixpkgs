{ attrs
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, lib
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "grafanalib";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yQIDAQMG84onYWqBxIl5IXSaBlJBO/uUIy4CVvoFyGk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    attrs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "grafanalib"
  ];

  meta = with lib; {
    description = "Library for building Grafana dashboards";
    homepage = "https://github.com/weaveworks/grafanalib/";
    changelog = "https://github.com/weaveworks/grafanalib/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
}
