{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  zarith,
  zarith_stubs_js ? null,
  integers_stubs_js,
  integers,
  hex,
  alcotest,
}:

buildDunePackage rec {
  pname = "bls12-381";
  version = "6.1.0";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "cryptography/ocaml-bls12-381";
    rev = version;
    hash = "sha256-z2ZSOrXgm+XjdrY91vqxXSKhA0DyJz6JkkNljDZznX8=";
  };

  minimalOCamlVersion = "4.08";

  postPatch = ''
    patchShebangs ./src/*.sh
  '';

  propagatedBuildInputs = [
    zarith
    zarith_stubs_js
    integers_stubs_js
    hex
    integers
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    homepage = "https://nomadic-labs.gitlab.io/cryptography/ocaml-bls12-381/bls12-381/";
    description = "Implementation of BLS12-381 and some cryptographic primitives built on top of it";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
