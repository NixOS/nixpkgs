{
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grafanalib";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "grafanalib";
    tag = "v${version}";
    hash = "sha256-vXnyAfC9avKz8U4+MJVnu2zoPD0nR2qarWYidhEPW5s=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ attrs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "grafanalib" ];

  meta = {
    description = "Library for building Grafana dashboards";
    homepage = "https://github.com/weaveworks/grafanalib/";
    changelog = "https://github.com/weaveworks/grafanalib/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ michaelgrahamevans ];
  };
}
