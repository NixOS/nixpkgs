{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, xz
, python
, pythonOlder
}:

if !(pythonOlder "3.3") then null else buildPythonPackage rec {
  pname = "backports.lzma";
  version = "0.0.14";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "16d8b68e4d3cd4e6c9ddb059850452946da3914c8a8e197a7f2b0954559f2df4";
  };

  buildInputs = [ xz ];

  checkPhase = ''
    ${python.interpreter} test/test_lzma.py
  '';

  # Relative import does not seem to function.
  doCheck = false;

  meta = {
    description = "Backport of Python 3.3's 'lzma' module for XZ/LZMA compressed files";
    homepage = "https://github.com/peterjc/backports.lzma";
    license = lib.licenses.bsd3;
  };
}
