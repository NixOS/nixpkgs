{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstring";
  version = "3.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rv0x3vicjz7df6jq13aypgfqqjvlz0b92ya9li8a5qicczqm155";
  };

  meta = with lib; {
    description = "Module for binary data manipulation";
    homepage = "https://github.com/scott-griffiths/bitstring";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
