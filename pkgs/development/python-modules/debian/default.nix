{ stdenv, buildPythonPackage, fetchPypi
, chardet, six}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "193faznwnjc3n5991wyzim6h9gyq1zxifmfrnpm3avgkh7ahyynh";
  };

  propagatedBuildInputs = [ chardet six ];
}
