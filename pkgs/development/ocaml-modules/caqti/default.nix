{ lib, fetchurl, buildDunePackage, ocaml
, cppo, logs, ptime, uri, bigstringaf
, re, cmdliner, alcotest
}:

buildDunePackage rec {
  pname = "caqti";
  version = "1.9.1";

  minimalOCamlVersion = "4.04";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/paurkedal/ocaml-caqti/releases/download/v${version}/caqti-v${version}.tbz";
    sha256 = "sha256-PQBgJBNx3IcE6/vyNIf26a2xStU22LBhff8eM6UPaJ4=";
  };

  nativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [ logs ptime uri bigstringaf ];
  checkInputs = [ re cmdliner alcotest ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "Unified interface to relational database libraries";
    license = "LGPL-3.0-or-later WITH OCaml-LGPL-linking-exception";
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://github.com/paurkedal/ocaml-caqti";
  };
}
