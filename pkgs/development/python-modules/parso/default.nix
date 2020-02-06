{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55cf25df1a35fd88b878715874d2c4dc1ad3f0eebd1e0266a67e1f55efccfbe1";
  };

  checkInputs = [ pytest ];

  meta = {
    description = "A Python Parser";
    homepage = https://github.com/davidhalter/parso;
    license = lib.licenses.mit;
  };

}
