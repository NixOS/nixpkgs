{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pybind11
, setuptools
, wheel
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "floret";
  version = "0.10.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "floret";
    rev = "refs/tags/v${version}";
    hash = "sha256-cOVyvRwprR7SvZjH4rtDK8uifv6+JGyRR7XYzOP5NLk=";
  };

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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "FastText + Bloom embeddings for compact, full-coverage vectors with spaCy";
    homepage = "https://github.com/explosion/floret";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
