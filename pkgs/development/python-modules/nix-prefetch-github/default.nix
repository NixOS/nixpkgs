{ fetchFromGitHub
, lib
, buildPythonPackage
, attrs
, click
, effect
, git
, pytestCheckHook
, pytest-cov
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nix-prefetch-github";
  version = "4.0.4";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    sha256 = "g5G818Gq5EGyRIyg/ZW7guxMS0IyJ4nYaRjG/CtGhuc=";
  };

  propagatedBuildInputs = [
    attrs
    click
    effect
  ];

  checkInputs = [ pytestCheckHook pytest-cov git ];

  # ignore tests which are impure
  disabledTests = [ "network" "requires_nix_build" ];

  meta = with lib; {
    description = "Prefetch sources from github";
    homepage = "https://github.com/seppeljordan/nix-prefetch-github";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seppeljordan ];
  };
}
