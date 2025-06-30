{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2025.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "hstspreload";
    tag = version;
    hash = "sha256-2KtQZroKhRzqFg0xL/gXMA3jP0FgYSPYy1eP3x78rQo=";
  };

  build-system = [ setuptools ];

  # Tests require network connection
  doCheck = false;

  pythonImportsCheck = [ "hstspreload" ];

  meta = with lib; {
    description = "Chromium HSTS Preload list as a Python package and updated daily";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
