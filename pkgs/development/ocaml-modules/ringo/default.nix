{ lib, fetchFromGitLab, buildDunePackage }:

buildDunePackage rec {
  pname = "ringo";
  version = "0.9";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "ringo";
    rev = "v${version}";
    sha256 = "sha256-lPb+WrRsmtOow9BX9FW4HoILlsTuuMrVlK0XPcXWZ9U=";
  };

  minimalOCamlVersion = "4.05";

  doCheck = true;

  # If we just run the test as is it will try to test ringo-lwt
  checkPhase = "dune build @test/runtest";

  meta = {
    description = "Caches (bounded-size key-value stores) and other bounded-size stores";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
