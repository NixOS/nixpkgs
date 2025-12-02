{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyjson5";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kijewski";
    repo = "pyjson5";
    tag = "v${version}";
    hash = "sha256-vHO354ZjaQirOWavfaDvenE+MLQLhWF3bCHa5Z1NNXg=";
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
