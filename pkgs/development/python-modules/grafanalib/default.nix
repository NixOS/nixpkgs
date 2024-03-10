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
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vXnyAfC9avKz8U4+MJVnu2zoPD0nR2qarWYidhEPW5s=";
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
