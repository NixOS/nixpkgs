{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pytricia";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05cvq7r3mv7xq72ziwr3vl8s4a6246vdhmhs39jvg8amrvyhlv3z";
  };

  meta = with lib; {
    description = "An efficient IP address storage and lookup module for Python";
    homepage = "https://github.com/jsommers/pytricia";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ mkg ];
  };
}
