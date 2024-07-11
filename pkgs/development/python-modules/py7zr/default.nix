{ lib
, buildPythonPackage
, fetchPypi

, setuptools
, setuptools-scm


, brotli
, inflate64
, multivolumefile
, psutil
, pybcj
, pycryptodomex
, pyppmd
, pyzstd
, texttable

}:
buildPythonPackage rec {
  pname = "py7zr";
  version = "0.21.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3t6O2LezKzWGrEdto6SCtp3UMyKUIL8PYsSVQEtyx5k=";
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

  meta = with lib; {
    homepage = "https://github.com/miurahr/py7zr";
    description = "7zip in python3 with ZStandard, PPMd, LZMA2, LZMA1, Delta, BCJ, BZip2";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ByteSudoer ];
  };
}
