{ lib, fetchFromGitHub, buildDunePackage, cppo, logs, ptime, uri }:

buildDunePackage rec {
  pname = "caqti";
  version = "1.5.1";
  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "paurkedal";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    sha256 = "1vl61kdyj89whc3mh4k9bis6rbj9x2scf6hnv9afyalp4j65sqx1";
  };

  nativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [ logs ptime uri ];

  meta = {
    description = "Unified interface to relational database libraries";
    license = "LGPL-3.0-or-later WITH OCaml-LGPL-linking-exception";
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://github.com/paurkedal/ocaml-caqti";
  };
}
