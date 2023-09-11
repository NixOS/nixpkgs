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
    description = "Nim implementation of the Syndicated Actor model";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
