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
<<<<<<< HEAD
  version = "7.0.0";
=======
  version = "6.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oIR2iEiOBQ1VKouJTLqEiWWNzrMSJcnxK+m/j9Ia/m8=";
=======
    sha256 = "tvoDSqg4g517c1w0VcsVm3r4mBFG3RHaOTAJAv1ooc4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
