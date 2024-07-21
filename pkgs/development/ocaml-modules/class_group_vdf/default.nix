{ stdenv, lib, fetchFromGitLab, buildDunePackage
, gmp, pkg-config, dune-configurator
, zarith, integers
, alcotest, bisect_ppx
}:

buildDunePackage (rec {
  pname = "class_group_vdf";
  version = "0.0.4";
  duneVersion = "3";

  src = fetchFromGitLab {
    owner = "nomadic-labs/cryptography";
    repo = "ocaml-chia-vdf";
    rev = "v${version}";
    hash = "sha256-KvpnX2DTUyfKARNWHC2lLBGH2Ou2GfRKjw05lu4jbBs=";
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
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
# Darwin sdk on intel target 10.12 (2016) at the time of writing. It is likely that host will be at least 10.14 (2018). This fix allow it to build and run on 10.14 and build on 10.12 (but don't run).
// lib.optionalAttrs (lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.14" && stdenv.hostPlatform.isMacOS && stdenv.hostPlatform.isx86_64) {
  preHook = ''
    export MACOSX_DEPLOYMENT_TARGET=10.14
  '';
})
