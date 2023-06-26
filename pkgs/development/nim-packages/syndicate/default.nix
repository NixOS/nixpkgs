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
  meta = src.meta // {
    description = "Nim implementation of the Syndicated Actor model";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
