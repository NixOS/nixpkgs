{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "908e9fae2144a076d72ae4e25539143d40b8e3eafbaeae03c1bfe226f4cdf12c";
  };

  checkInputs = [ pytest ];

  meta = {
    description = "A Python Parser";
    homepage = "https://github.com/davidhalter/parso";
    license = lib.licenses.mit;
  };

}
