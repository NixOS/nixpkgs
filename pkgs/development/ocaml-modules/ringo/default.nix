{ lib, fetchFromGitLab, buildDunePackage }:

buildDunePackage rec {
  pname = "ringo";
  version = "0.5";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "ringo";
    rev = "v${version}";
    sha256 = "1zwha0ycv3rm3qnw7nkg2m08ibx39yxnx5fan4lnn82b0pdasjag";
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
