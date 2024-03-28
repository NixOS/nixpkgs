{ lib, fetchPypi, buildPythonPackage, pythonAtLeast }:

buildPythonPackage rec {
  pname = "ed25519";
  version = "1.5";
  format = "setuptools";

  # last commit in 2019, various compat issues with 3.12
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n1k83ww0pr4q6z0h7p8hvy21hcgb96jvgllfbwhvvyf37h3w182";
  };

  meta = with lib; {
    description = "Ed25519 public-key signatures";
    mainProgram = "edsig";
    homepage = "https://github.com/warner/python-ed25519";
    license = licenses.mit;
    maintainers = with maintainers; [ np ];
  };
}
