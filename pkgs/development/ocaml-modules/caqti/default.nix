{ lib, fetchFromGitHub, buildDunePackage, ocaml
, cppo, logs, ptime, uri, bigstringaf
, re, cmdliner, alcotest }:

buildDunePackage rec {
  pname = "caqti";
  version = "1.8.0";
  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "paurkedal";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    sha256 = "sha256-8uKlrq9j1Z3QzkCyoRIn2j6wCdGyo7BY7XlbFHN1xVE=";
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
