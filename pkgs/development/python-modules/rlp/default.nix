{ lib, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "rlp";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "492c11b18e89af42f98e96bca7671ffee4ad4cf5e69ea23b4d2221157d81b512";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ ];

  meta = {
    description = "A package for encoding and decoding data in and from Recursive Length Prefix notation";
    homepage = "https://github.com/ethereum/pyrlp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
