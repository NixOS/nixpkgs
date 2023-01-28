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
  version = "6.0.0";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    sha256 = "YobBihNPbqYYWhe3x0p+BIlEK8R62s/dDFWUzP7fCTI=";
  };

  nativeCheckInputs = [ unittestCheckHook git which ];

  # ignore tests which are impure
  DISABLED_TESTS = "network requires_nix_build";

  meta = with lib; {
    description = "Prefetch sources from github";
    homepage = "https://github.com/seppeljordan/nix-prefetch-github";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seppeljordan ];
  };
}
