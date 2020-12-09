{ fetchFromGitHub
, lib
, buildPythonPackage
, attrs
, click
, effect
, git
, pytestCheckHook
, pytestcov
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nix-prefetch-github";
  version = "4.0.3";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    sha256 = "CLcmwobPrL6NiI/nw+/Dwho/r15owV16Jmt5OcfFqvo=";
  };

  propagatedBuildInputs = [
    attrs
    click
    effect
  ];

  checkInputs = [ pytestCheckHook pytestcov git ];

  # ignore tests which are impure
  disabledTests = [ "network" "requires_nix_build" ];

  meta = with lib; {
    description = "Prefetch sources from github";
    homepage = "https://github.com/seppeljordan/nix-prefetch-github";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seppeljordan ];
  };
}
