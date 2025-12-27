{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "mistralai";
  version = "1.9.11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "client-python";
    rev = "v${version}";
    hash = "sha256-34+HK4kTY1fcNWqiEJ/j5CA3xynO9DO3TCblndAJmmg=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    eval-type-backport
    httpx
    invoke
    pydantic
    python-dateutil
    pyyaml
    typing-inspection
  ];

  optional-dependencies = with python3Packages; {
    agents = [
      authlib
      griffe
      mcp
    ];
    gcp = [
      google-auth
      requests
    ];
  };

  # Fix README file for PyPI
  patchPhase = ''
    substituteInPlace pyproject.toml \
      --replace 'readme = "README-PYPI.md"' 'readme = "README.md"'
  '';

  pythonImportsCheck = [ "mistralai" ];

  meta = {
    description = "Python Client SDK for the Mistral AI API";
    homepage = "https://github.com/mistralai/client-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mana-byte ];
  };
}
