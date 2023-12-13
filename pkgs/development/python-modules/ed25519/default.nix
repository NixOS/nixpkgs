{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "ed25519";
  version = "1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n1k83ww0pr4q6z0h7p8hvy21hcgb96jvgllfbwhvvyf37h3w182";
  };

  meta = with lib; {
    description = "Ed25519 public-key signatures";
    homepage = "https://github.com/warner/python-ed25519";
    license = licenses.mit;
    maintainers = with maintainers; [ np ];
  };
}
