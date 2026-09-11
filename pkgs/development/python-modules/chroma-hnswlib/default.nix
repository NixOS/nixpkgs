{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pybind11,
  setuptools,
  wheel,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "chroma-hnswlib";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "hnswlib";
    tag = version;
    hash = "sha256-Fs/BuocZblMSlmP6yp+aykbs0n1AdvL3AVAQI1AnZ9o=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '__version__ = "0.7.6"' '__version__ = "${version}"'
  '';

  nativeBuildInputs = [
    numpy
    pybind11
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hnswlib" ];

  meta = {
    description = "Header-only C++/python library for fast approximate nearest neighbors";
    homepage = "https://github.com/chroma-core/hnswlib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
