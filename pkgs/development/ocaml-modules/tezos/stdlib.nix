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
}:

buildDunePackage rec {
  pname = "tezos-stdlib";
  version = "8.3";
  src = fetchFromGitLab {
    owner = "tezos";
    repo = "tezos";
    rev = "v${version}";
    sha256 = "1ykhz5m5sb2hq04nspbsbq8wspkhimagb5g6yi65hpdbn8f4zr6h";
  };

  minimalOCamlVersion = "4.0.8";

  useDune2 = true;

  preBuild = ''
    rm -rf vendors
  '';

  propagatedBuildInputs = [
    hex
    lwt
    zarith
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
    crowbar
    bigstring
    lwt_log
  ];

  doCheck = true;

  meta = {
    description = "Tezos: yet-another local-extension of the OCaml standard library";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
