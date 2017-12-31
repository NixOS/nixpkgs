{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, lzma
, python
}:

buildPythonPackage rec {
  pname = "backports.lzma";
  version = "0.0.8";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "200584ad5079d8ca6b1bfe14890c7be58666ab0128d8ca26cfb2669b476085f3";
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