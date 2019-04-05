{ buildPythonPackage, fetchPypi, attrs, protobuf, zeroconf }:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16ywa7yggmsx8m2r9azdq7w9fxjh736g1vd1aibgh24g7srhwwhj";
  };

  propagatedBuildInputs = [ attrs protobuf zeroconf ];

  meta = {};
}
