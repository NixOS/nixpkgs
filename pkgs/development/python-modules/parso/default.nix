{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0604a40b96e062b0fd99cf134cc2d5cdf66939d0902f8267d938b0d5b26707f";
  };

  checkInputs = [ pytest ];

  meta = {
    description = "A Python Parser";
    homepage = https://github.com/davidhalter/parso;
    license = lib.licenses.mit;
  };

}
