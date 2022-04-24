{ lib
, fetchFromGitLab
, buildDunePackage
, hex
, lwt
, zarith
, alcotest
, alcotest-lwt
, crowbar
, bigstring
, lwt_log
, ppx_inline_test
, qcheck-alcotest
, tezos-test-helpers
}:

buildDunePackage rec {
  pname = "tezos-stdlib";
  version = "11.0";
  base_src = fetchFromGitLab {
    owner = "tezos";
    repo = "tezos";
    rev = "v${version}";
    sha256 = "uUYd1DxH2bdCQlevQt3oGxvg0ai5EiCD2mti5SiueU8=";
  };

  src = "${base_src}/src/lib_stdlib";

  minimalOCamlVersion = "4.08";

  useDune2 = true;

  preBuild = ''
    rm -rf vendors
  '';

  propagatedBuildInputs = [
    hex
    lwt
    zarith
    ppx_inline_test
  ];

  checkInputs = [
    bigstring
    lwt_log
    alcotest
    alcotest-lwt
    crowbar
    bigstring
    lwt_log
    qcheck-alcotest
    # tezos-test-helpers
  ];

  # circular dependency if we add this
  doCheck = false;

  meta = {
    description = "Tezos: yet-another local-extension of the OCaml standard library";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
