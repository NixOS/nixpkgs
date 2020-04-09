{ lib, buildPythonPackage, fetchPypi, py, lxml, pytest }:

buildPythonPackage rec {
  pname = "pyshark";
  version = "0.4.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l7dsxyxm1diqq15mfqy7qaf9vzpgqbkn46yffskr88j1jyv3gz7";
  };

  propagatedBuildInputs = [
    py
    lxml
    pytest
  ];

  meta = with lib; {
    description = "Python wrapper for tshark, allowing python packet parsing using wireshark dissectors";
    homepage = "https://github.com/KimiNewt/pyshark/";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
