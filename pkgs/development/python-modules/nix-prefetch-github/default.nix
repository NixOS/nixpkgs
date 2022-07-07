{ fetchFromGitHub
, lib
, buildPythonPackage
, git
, which
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nix-prefetch-github";
  version = "5.1.2";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    sha256 = "GHUH3Oog800qrdgXs5AEa4O6ovZ1LT0k3P4YwEHfwlY=";
  };

  checkInputs = [ git which ];

  checkPhase = ''
    python -m unittest discover
  '';
  # ignore tests which are impure
  DISABLED_TESTS = "network requires_nix_build";

  meta = with lib; {
    description = "Prefetch sources from github";
    homepage = "https://github.com/seppeljordan/nix-prefetch-github";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seppeljordan ];
  };
}
