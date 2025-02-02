{
  brotli,
  buildPythonPackage,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "miurahr";
    repo = "py7zr";
    tag = "v${version}";
    hash = "sha256-YR2cuHZWwqrytidAMbNvRV1/N4UZG8AMMmzcTcG9FvY=";
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

  meta = {
    homepage = "https://github.com/miurahr/py7zr";
    description = "7zip in Python 3 with ZStandard, PPMd, LZMA2, LZMA1, Delta, BCJ, BZip2";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };
}
