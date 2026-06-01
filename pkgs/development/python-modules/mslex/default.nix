{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
}:

buildPythonPackage rec {
  pname = "mslex";
  version = "1.3.0";
  pyproject = true; # fallback to setup.py if pyproject.toml is not present

  src = fetchFromGitHub {
    owner = "smoofra";
    repo = "mslex";
    tag = "v${version}";
    hash = "sha256-vr36OTCTJFZRXlkeGgN4UOlH+6uAkMvqTEO9qL8X98w=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "mslex"
  ];

  nativeCheckInputs = [
    pytest
  ];

  meta = {
    description = "Like shlex, but for windows";
    homepage = "https://github.com/smoofra/mslex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
