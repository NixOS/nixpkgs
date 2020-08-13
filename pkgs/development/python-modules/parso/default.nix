{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "caba44724b994a8a5e086460bb212abc5a8bc46951bf4a9a1210745953622eb9";
  };

  checkInputs = [ pytest ];

  meta = {
    description = "A Python Parser";
    homepage = "https://github.com/davidhalter/parso";
    license = lib.licenses.mit;
  };

}
