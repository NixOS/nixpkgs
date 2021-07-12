{ lib
, buildPythonPackage
, fetchFromGitHub
, git
, pythonOlder
, pytestCheckHook
, ruamel_yaml
, toml
}:

buildPythonPackage rec {
  pname = "pre-commit-hooks";
  version = "4.0.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Rg2I79r0Pp3AUgT6mD+kEdm+5CEGgdmFn6G3xcU6fnk=";
  };

  propagatedBuildInputs = [
    ruamel_yaml
    toml
  ];

  checkInputs = [
    git
    pytestCheckHook
  ];

  # the tests require a functional git installation which requires a valid HOME
  # directory.
  preCheck = ''
    export HOME="$(mktemp -d)"

    git config --global user.name "Nix Builder"
    git config --global user.email "nix-builder@nixos.org"
  '';

  pythonImportsCheck = [ "pre_commit_hooks" ];

  meta = with lib; {
    description = "Some out-of-the-box hooks for pre-commit";
    homepage = "https://github.com/pre-commit/pre-commit-hooks";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
