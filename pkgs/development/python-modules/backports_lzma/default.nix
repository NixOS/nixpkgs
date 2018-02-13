{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, lzma
, python
, pythonOlder
}:

if !(pythonOlder "3.3") then null else buildPythonPackage rec {
  pname = "backports.lzma";
  version = "0.0.9";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ba5d94214a79900ee297a594b8e154cd8e4a54d26eb06243c0e2f3ad5286539";
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