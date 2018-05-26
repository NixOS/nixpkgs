{ lib, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "rlp";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d3gx4mp8q4z369s5yk1n9c55sgfw9fidbwqxq67d6s7l45rm1w7";
  };

  buildInputs = [ pytest ];

  meta = {
    description = "A package for encoding and decoding data in and from Recursive Length Prefix notation";
    homepage = "https://github.com/ethereum/pyrlp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
