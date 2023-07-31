{ lib, buildNimPackage, fetchFromGitea, hashlib, preserves }:

buildNimPackage rec {
  pname = "syndicate";
  version = "20230530";
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "${pname}-nim";
    rev = version;
    hash = "sha256-lUHoMSQwUlz9EDMvpFL9GlrwbwMvZDILSmuakONwe50=";
  };
  propagatedBuildInputs = [ hashlib preserves ];
  meta = src.meta // {
    description = "Nim implementation of the Syndicated Actor model";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
