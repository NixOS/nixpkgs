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
  version = "0.8.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "hnswlib";
    tag = version;
    hash = "sha256-Fs/BuocZblMSlmP6yp+aykbs0n1AdvL3AVAQI1AnZ9o=";
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
