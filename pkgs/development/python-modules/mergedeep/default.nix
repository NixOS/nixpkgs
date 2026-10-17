{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
}:

buildPythonPackage rec {
  pname = "mergedeep";
  version = "1.3.4";
  format = "setuptools";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "clarketm";
    repo = "mergedeep";
    rev = "v${version}";
    hash = "sha256-yRB0GqoIFu6BHuijAaR0J+qsaUPaEb39+12PMX/bW9c=";
  };

  nativeCheckInputs = [ pytest ];
  checkPhase = "pytest";
  pythonImportsCheck = [ "mergedeep" ];

  meta = {
    homepage = "https://github.com/clarketm/mergedeep";
    description = "Deep merge function for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ris ];
  };
}
