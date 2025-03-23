{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pyvex,
  setuptools,
  typing-extensions,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "ailment";
  version = "9.2.147";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "ailment";
    tag = "v${version}";
    hash = "sha256-WrqkTNFhttpLG1dG05+nnqzoPUQPZUG15JooChBIKEA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyvex
    typing-extensions
  ];

  # Tests depend on angr (possibly a circular dependency)
  doCheck = false;

  pythonImportsCheck = [ "ailment" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Angr Intermediate Language";
    homepage = "https://github.com/angr/ailment";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
