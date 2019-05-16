{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "68406ebd7eafe17f8e40e15a84b56848eccbf27d7c1feb89e93d8fca395706db";
  };

  checkInputs = [ pytest ];

  meta = {
    description = "A Python Parser";
    homepage = https://github.com/davidhalter/parso;
    license = lib.licenses.mit;
  };

}
