{ lib, buildDunePackage, ocaml, fetchurl, alcotest }:

buildDunePackage rec {
  pname = "terminal_size";
  version = "0.2.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/cryptosense/terminal_size/releases/download/v${version}/terminal_size-${version}.tbz";
    hash = "sha256-1rYs0oxAcayFypUoCIdFwSTJCU7+rpFyJRRzb5lzsPs=";
  };

  checkInputs = [ alcotest ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = with lib; {
    description = "Get the dimensions of the terminal";
    homepage = "https://github.com/cryptosense/terminal_size";
    license = licenses.bsd2;
    maintainers = [ maintainers.sternenseemann ];
  };
}
