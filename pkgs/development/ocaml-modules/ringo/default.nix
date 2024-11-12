{ lib, fetchFromGitLab, buildDunePackage }:

buildDunePackage rec {
  pname = "ringo";
  version = "1.1.0";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "ringo";
    rev = "v${version}";
    hash = "sha256-8dThhY7TIjd0lLdCt6kxr0yhgVGDyN6ZMSx0Skfbcwk=";
  };

  minimalOCamlVersion = "4.08";

  doCheck = true;

  meta = {
    description = "Caches (bounded-size key-value stores) and other bounded-size stores";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
