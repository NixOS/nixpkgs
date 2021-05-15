{ buildPythonPackage
, fetchFromGitHub
, fetchPypi
, git
, isPy27
, lib
, pytestCheckHook
, ruamel_yaml
, toml
}:

buildPythonPackage rec {
  pname = "pre-commit-hooks";
  version = "3.4.0";
  disabled = isPy27;

  # fetchPypi does not provide tests
  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "v${version}";
    sha256 = "1aqkmprdc2lhds9c59pkkf2js65j63197flanaggk7cm8k0kz7zs";
  };

  propagatedBuildInputs = [ toml ruamel_yaml ];
  checkInputs = [ git pytestCheckHook ];

  # the tests require a functional git installation which requires a valid HOME
  # directory.
  preCheck = ''
    export HOME="$(mktemp -d)"

    git config --global user.name "Nix Builder"
    git config --global user.email "nix-builder@nixos.org"
  '';

  meta = with lib; {
    description = "Some out-of-the-box hooks for pre-commit";
    homepage = "https://github.com/pre-commit/pre-commit-hooks";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
