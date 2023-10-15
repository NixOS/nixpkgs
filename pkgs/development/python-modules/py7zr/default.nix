{ lib
, buildPythonPackage
, fetchPypi
, brotli
, brotlicffi
, importlib-metadata
, psutil
, pycryptodomex
, texttable
, poetry-core
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "py7zr";
  version = "0.20.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0Dbe4R/Oaa2NT6hgJcz8SjUR7CfuHGtb2NZ1kxPb0Hc=";
  };

  propagatedBuildInputs = [
    brotli
    brotlicffi
    importlib-metadata
 #   inflate64
 #   multivolumefile
    psutil
 #   pybcj
    pycryptodomex
  # pyppmd
#    pyzstd
    texttable
    poetry-core
    setuptools
    setuptools-scm
  ];



  meta = with lib; {
    description = "Pure python 7-zip library";
    homepage = "https://github.com/miurahr/py7zr";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ provenzano ];
  };
}
