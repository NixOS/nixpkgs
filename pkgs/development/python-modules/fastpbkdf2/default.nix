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
    sha256 = "1hvvlk3j28i6nswb6gy3mq7278nq0mgfnpxh1rv6jvi7xhd7qmlc";
  };

  buildInputs = [ openssl ];
  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [
    cffi
    six
  ];
  propagatedNativeBuildInputs = [ cffi ];

  meta = with lib; {
    homepage = "https://github.com/Ayrx/python-fastpbkdf2";
    description = "Python bindings for fastpbkdf2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jqueiroz ];
  };
}
