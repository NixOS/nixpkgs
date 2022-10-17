{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, git
, pytestCheckHook
, pythonOlder
, ruamel-yaml
, toml
}:

buildPythonPackage rec {
  pname = "pre-commit-hooks";
  version = "4.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-qdsSM+7ScSfxhmLAqwi1iraGHrhb5NBee/j+TKr2WUA=";
  };

  propagatedBuildInputs = [
    ruamel-yaml
    toml
  ];

  checkInputs = [
    git
    pytestCheckHook
  ];

  # Note: this is not likely to ever work on Darwin
  # https://github.com/pre-commit/pre-commit-hooks/pull/655
  doCheck = !stdenv.isDarwin;

  # the tests require a functional git installation which requires a valid HOME
  # directory.
  preCheck = ''
    export HOME="$(mktemp -d)"

    git config --global user.name "Nix Builder"
    git config --global user.email "nix-builder@nixos.org"
    git init .
  '';

  pythonImportsCheck = [
    "pre_commit_hooks"
  ];

  meta = with lib; {
    description = "Some out-of-the-box hooks for pre-commit";
    homepage = "https://github.com/pre-commit/pre-commit-hooks";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
