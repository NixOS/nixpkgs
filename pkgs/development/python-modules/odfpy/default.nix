{ lib
, buildPythonPackage
, fetchPypi
, defusedxml
, pytest
}:

buildPythonPackage rec {
  pname = "odfpy";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v1qqk9p12qla85yscq2g413l3qasn6yr4ncyc934465b5p6lxnv";
  };

  propagatedBuildInputs = [ defusedxml ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "Python API and tools to manipulate OpenDocument files";
    homepage = https://github.com/eea/odfpy;
    license = lib.licenses.asl20;
  };
}
