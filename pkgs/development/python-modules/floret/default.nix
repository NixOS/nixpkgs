{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pybind11,
  setuptools,
  wheel,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "floret";
  version = "0.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "floret";
    tag = "v${version}";
    hash = "sha256-7vkw6H0ZQoHEwNusY6QWh/vPbSCdP1ZaaqABHsZH6hQ=";
  };

  patches = [ ./cstdint.patch ];

  nativeBuildInputs = [
    pybind11
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    pybind11
  ];

  pythonImportsCheck = [ "floret" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "FastText + Bloom embeddings for compact, full-coverage vectors with spaCy";
    homepage = "https://github.com/explosion/floret";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
