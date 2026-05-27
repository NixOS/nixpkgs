{
  lib,
  fetchurl,
  buildDunePackage,
  camlp-streams,
  decompress,
}:

buildDunePackage rec {
  pname = "tar";
  version = "3.4.0";
  src = fetchurl {
    url = "https://github.com/mirage/ocaml-tar/releases/download/v${version}/tar-${version}.tbz";
    hash = "sha256-JW4QQ08cL0B85iDfDkYRii1Kq+iecsZNDclBl7LV8dQ=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    camlp-streams
    decompress
  ];

  doCheck = true;

  meta = {
    description = "Decode and encode tar format files in pure OCaml";
    homepage = "https://github.com/mirage/ocaml-tar";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
