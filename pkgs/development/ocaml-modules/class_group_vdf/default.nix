{ stdenv, lib, fetchFromGitLab, buildDunePackage
, gmp, pkg-config, dune-configurator
, zarith, integers
, alcotest, bisect_ppx
}:

buildDunePackage rec {
  pname = "class_group_vdf";
  version = "0.0.4";
  duneVersion = "3";

  src = fetchFromGitLab {
    owner = "nomadic-labs/cryptography";
    repo = "ocaml-chia-vdf";
    rev = "v${version}";
    sha256 = "sha256-KvpnX2DTUyfKARNWHC2lLBGH2Ou2GfRKjw05lu4jbBs=";
  };

  minimalOCamlVersion = "4.08";

  nativeBuildInputs = [
    gmp
    pkg-config
    dune-configurator
  ];

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    zarith
    integers
  ];

  checkInputs = [
    alcotest
    bisect_ppx
  ];

  doCheck = true;

  meta = {
    description = "Verifiable Delay Functions bindings to Chia's VDF";
    homepage = "https://gitlab.com/nomadic-labs/tezos";
    broken = stdenv.isDarwin && stdenv.isx86_64;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
