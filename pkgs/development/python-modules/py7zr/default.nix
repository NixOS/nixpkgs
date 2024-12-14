{
  brotli,
  buildPythonPackage,
  fetchPypi,
  inflate64,
  lib,
  multivolumefile,
  psutil,
  pybcj,
  pycryptodomex,
  pyppmd,
  pyzstd,
  setuptools,
  setuptools-scm,
  texttable,
}:

buildPythonPackage rec {
  pname = "py7zr";
  version = "0.22.0";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xseupZE1NRhAA7c5OEkPmk2EGFmOUz+cqZHTuORaE54=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    brotli
    inflate64
    multivolumefile
    psutil
    pybcj
    pycryptodomex
    pyppmd
    pyzstd
    texttable
  ];

  pythonImportsCheck = [ "py7zr" ];

  meta = {
    homepage = "https://github.com/miurahr/py7zr";
    description = "7zip in python3 with ZStandard, PPMd, LZMA2, LZMA1, Delta, BCJ, BZip2";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };
}
