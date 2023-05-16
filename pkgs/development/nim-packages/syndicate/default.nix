<<<<<<< HEAD
{ lib, buildNimPackage, fetchFromGitea, hashlib, preserves }:

buildNimPackage (final: prev: {
  pname = "syndicate";
  version = "20230801";
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "syndicate-nim";
    rev = final.version;
    hash = "sha256-/mZGWVdQ5FtZf2snPIjTG2tNFVzxQmxvkKuLCAGARYs=";
  };
  propagatedBuildInputs = [ hashlib preserves ];
  nimFlags = [ "--mm:refc" "--threads:off" ];
  meta = final.src.meta // {
=======
{ lib, buildNimPackage, fetchFromGitea, nimSHA2, preserves }:

buildNimPackage rec {
  pname = "syndicate";
  version = "20221102";
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "${pname}-nim";
    rev = version;
    hash = "sha256-yTPbEsBcpEPXfmhykbWzWdnJ2ExEJxdii1L+mqx8VGQ=";
  };
  propagatedBuildInputs = [ nimSHA2 preserves ];
  doCheck = true;
  meta = src.meta // {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Nim implementation of the Syndicated Actor model";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
