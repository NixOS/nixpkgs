{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, lzma
, python
}:

buildPythonPackage rec {
  pname = "backports.lzma";
  version = "0.0.3";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bac58aec8d39ac3d22250840fb24830d0e4a0ef05ad8f3f09172dc0cc80cdbca";
  };

  buildInputs = [ lzma ];

  # Needs the compiled module in $out
  checkPhase = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH ${python.interpreter} -m unittest discover -s test
  '';

  meta = {
    description = "Backport of Python 3.3's 'lzma' module for XZ/LZMA compressed files";
    homepage = https://github.com/peterjc/backports.lzma;
    license = lib.licenses.bsd3;
  };
}