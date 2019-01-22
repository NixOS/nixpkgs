{ buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  # also bump cryptography
  pname = "cryptography_vectors";
  version = "2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15qfl3pnw2f11r0z0zhwl56f6pb60ysav8fxmpnz5p80cfwljdik";
  };

  # No tests included
  doCheck = false;
}
