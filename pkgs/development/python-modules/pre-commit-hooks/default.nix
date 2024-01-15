{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, git
, pytestCheckHook
, pythonOlder
, ruamel-yaml
, tomli
}:

buildPythonPackage rec {
  pname = "pre-commit-hooks";
  version = "4.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EiPGdrpD4e9izRNJCjHRp+gR+ClzFtLjs6P57WXDs7I=";
  };

  propagatedBuildInputs = [
    ruamel-yaml
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/pre-commit/pre-commit-hooks/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
