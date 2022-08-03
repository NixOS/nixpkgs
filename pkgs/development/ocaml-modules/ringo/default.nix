{ lib, fetchFromGitLab, buildDunePackage }:

buildDunePackage rec {
  pname = "ringo";
  version = "0.9";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "ringo";
    rev = "v${version}";
    sha256 = "1mb7sv2ks5xdjkawmf7fqjb0p0hyp1az8myhqfld76kcnidgxxll";
  };

  minimalOCamlVersion = "4.05";

  useDune2 = true;

  doCheck = true;

  # If we just run the test as is it will try to test ringo-lwt
  checkPhase = "dune build @test/runtest";

  meta = {
    description = "Caches (bounded-size key-value stores) and other bounded-size stores";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
