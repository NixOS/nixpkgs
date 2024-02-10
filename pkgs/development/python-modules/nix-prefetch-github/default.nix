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
  version = "7.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "v${version}";
    hash = "sha256-oIR2iEiOBQ1VKouJTLqEiWWNzrMSJcnxK+m/j9Ia/m8=";
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
