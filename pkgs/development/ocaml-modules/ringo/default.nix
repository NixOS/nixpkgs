{
  lib,
  fetchFromGitLab,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "ringo";
  version = "1.0.0";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "ringo";
    rev = "v${version}";
    sha256 = "sha256-9HW3M27BxrEPbF8cMHwzP8FmJduUInpQQAE2672LOuU=";
  };

  minimalOCamlVersion = "4.08";

  doCheck = true;

  meta = {
    description = "Caches (bounded-size key-value stores) and other bounded-size stores";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
