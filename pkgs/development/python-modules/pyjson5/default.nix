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
  version = "1.6.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Kijewski";
    repo = "pyjson5";
    tag = "v${version}";
    hash = "sha256-3Mj5Kjas+uArTEt0c6NxWgQBVWjPVKhQ+ET1npAlpt8=";
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
    changelog = "https://github.com/Kijewski/pyjson5/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
