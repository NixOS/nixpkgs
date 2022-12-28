{
  lib,
  fetchzip,
  buildDunePackage,
  bls12-381,
  alcotest,
  bisect_ppx,
  integers_stubs_js,
}:

buildDunePackage rec {
  pname = "bls12-381-signature";
  version = "1.0.0";
  src = fetchzip {
    url = "https://gitlab.com/nomadic-labs/cryptography/ocaml-${pname}/-/archive/${version}/ocaml-bls12-381-signature-${version}.tar.bz2";
    sha256 = "sha256-KaUpAT+BWxmUP5obi4loR9vVUeQmz3p3zG3CBolUuL4=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ bls12-381 ];

  checkInputs = [alcotest bisect_ppx integers_stubs_js];

  doCheck = true;

  meta = {
    description = "Implementation of BLS signatures for the pairing-friendly curve BLS12-381";
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/nomadic-labs/cryptography/ocaml-bls12-381-signature";
    maintainers = [lib.maintainers.ulrikstrid];
  };
}
