{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "n2g";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n1k83ww0pr4q6z0h7p8hvy21hcgb96jvgllfbwhvvyf37h3wlll";
  };

  meta = with lib; {
    description = "Ed25519 public-key signatures";
    homepage = "https://github.com/warner/python-ed25519";
    license = licenses.mit;
    maintainers = with maintainers; [ np ];
  };
}
