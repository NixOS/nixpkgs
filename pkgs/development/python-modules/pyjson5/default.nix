{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyjson5";
  version = "1.6.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Kijewski";
    repo = "pyjson5";
    rev = "refs/tags/v${version}";
    hash = "sha256-QggO1go9iQIy235I9CYOeC6JCoOT2sfDsrbSySN3mMw=";
    fetchSubmodules = true;
  };

  build-system = [
    cython
    setuptools
    wheel
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyjson5" ];

  meta = with lib; {
    description = "JSON5 serializer and parser library";
    homepage = "https://github.com/Kijewski/pyjson5";
    changelog = "https://github.com/Kijewski/pyjson5/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
