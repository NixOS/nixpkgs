{ fetchFromGitHub
, lib
, buildPythonPackage
, git
, which
, pythonOlder
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "nix-prefetch-github";
  version = "5.2.2";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    sha256 = "sha256-+0s47YhpMojxmRHKC7kazov2ZUsOs2/Y2EmHAAcARf0=";
  };

  checkInputs = [ unittestCheckHook git which ];

  # ignore tests which are impure
  DISABLED_TESTS = "network requires_nix_build";

  meta = with lib; {
    description = "Prefetch sources from github";
    homepage = "https://github.com/seppeljordan/nix-prefetch-github";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seppeljordan ];
  };
}
