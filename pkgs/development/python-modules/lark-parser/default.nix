{ lib, fetchPypi, buildPythonPackage }:
 buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.12.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FZZ9sfEhQBPcplsRgHRQR7m+RX1z2iJPzaPZ3U6WoTg=";
  };

  meta = with lib; {
    homepage = "https://github.com/lark-parser/lark";
    description = "A modern general-purpose parsing library";
    maintainers = with maintainers; [ avimitin ];
    license = licenses.mit;
  };
}
