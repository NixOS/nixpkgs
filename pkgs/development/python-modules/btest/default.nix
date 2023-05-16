{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "btest";
<<<<<<< HEAD
  version = "1.1";
=======
  version = "1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "btest";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-D01hAKcE52eKJRUh1/x5DGxRQpWgA2J0nutshpKrtRU=";
=======
    hash = "sha256-QvK2MZTx+DD2u+h7dk0F5kInXGVp73ZTvG080WV2BVQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # No tests available and no module to import
  doCheck = false;

  meta = with lib; {
    description = "A Generic Driver for Powerful System Tests";
    homepage = "https://github.com/zeek/btest";
    changelog = "https://github.com/zeek/btest/blob/${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
