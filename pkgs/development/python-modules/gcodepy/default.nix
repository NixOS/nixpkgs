{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gcodepy";
  version = "0.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "rmeno12";
    repo = "gcodepy";
    rev = "v${version}";
    hash = "sha256-+amBkwwISPyes8ABdqgCw50Zg5ioDa46WZgQsZZgl+8=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "gcodepy" ];

  meta = with lib; {
    description = "G-code generator for 3D printers that use Marlin Firmware";
    homepage = "https://github.com/rmeno12/gcodepy";
    changelog = "https://github.com/rmeno12/gcodepy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ n00b0ss ];
  };
}
