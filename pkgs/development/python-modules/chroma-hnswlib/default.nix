{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pybind11,
  setuptools,
  wheel,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "chroma-hnswlib";
  version = "0.7.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "hnswlib";
    rev = "refs/tags/${version}";
    hash = "sha256-KU/t37MZMFeNWPme+rgCHchZH7B8timIV2EH40laXkA=";
  };

  nativeBuildInputs = [
    numpy
    pybind11
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hnswlib" ];

  meta = with lib; {
    description = "Header-only C++/python library for fast approximate nearest neighbors";
    homepage = "https://github.com/chroma-core/hnswlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
