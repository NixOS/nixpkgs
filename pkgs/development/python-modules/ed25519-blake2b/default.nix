{ lib
, fetchPypi
, pythonOlder
, buildPythonPackage }:

buildPythonPackage rec {
  pname = "ed25519-blake2b";
  version = "1.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0aHLkDLsMHzpW0HGGUQP1NP87MGPIkA1zH1tx6fY70A=";
  };

  pythonImportsCheck = [
    "ed25519_blake2b"
  ];

  meta = with lib; {
    description = "Ed25519 public-key signatures (BLAKE2b fork)";
    homepage = "https://github.com/Matoking/python-ed25519-blake2b";
    license = licenses.mit;
    maintainers = with maintainers; [ onny stargate01 ];
  };
}
