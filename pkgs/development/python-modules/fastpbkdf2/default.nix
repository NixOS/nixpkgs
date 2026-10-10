{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  openssl,
  pytest,
  cffi,
  six,
}:

buildPythonPackage rec {
  pname = "fastpbkdf2";
  version = "0.2";
  format = "setuptools";

  # Fetching from GitHub as tests are missing in PyPI
  src = fetchFromGitHub {
    owner = "Ayrx";
    repo = "python-fastpbkdf2";
    rev = "v${version}";
    hash = "sha256-jFZ8Guwnbml2DrBf614F2KIjDq7DP7O4tiYiIceke8M=";
  };

  buildInputs = [ openssl ];
  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [
    cffi
    six
  ];
  propagatedNativeBuildInputs = [ cffi ];

  meta = {
    homepage = "https://github.com/Ayrx/python-fastpbkdf2";
    description = "Python bindings for fastpbkdf2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jqueiroz ];
  };
}
