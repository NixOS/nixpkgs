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
  version = "0.0.13";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "50829db66f0445442f6c796bba0ca62d1f87f54760c4682b6d1489e729a43744";
  };

  buildInputs = [ lzma ];

  # Needs the compiled module in $out
  checkPhase = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH ${python.interpreter} -m unittest discover -s test
  '';

  # Relative import does not seem to function.
  doCheck = false;

  meta = {
    description = "Backport of Python 3.3's 'lzma' module for XZ/LZMA compressed files";
    homepage = https://github.com/peterjc/backports.lzma;
    license = lib.licenses.bsd3;
  };
}