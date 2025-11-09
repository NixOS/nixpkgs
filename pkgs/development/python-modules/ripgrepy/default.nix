{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "ripgrepy";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "securisec";
    repo = "ripgrepy";
    rev = version;
    hash = "sha256-+Q9O6sLXgdhjxN6+cTJvNhVg6cr0jByETJrlpnc+FEQ=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "ripgrepy" ];

  meta = {
    description = "Python module for ripgrep";
    homepage = "https://github.com/securisec/ripgrepy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jinser ];
  };
}
