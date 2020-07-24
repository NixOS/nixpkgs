{ lib, fetchFromGitHub, buildDunePackage
, astring, cmdliner, cppo, fpath, result, tyxml
}:

buildDunePackage rec {
  pname = "odoc";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = version;
    sha256 = "0z2nisg1vb5xlk41hqw8drvj90v52wli7zvnih6a844cg6xsvvj2";
  };

  buildInputs = [ astring cmdliner cppo fpath result tyxml ];

  meta = {
    description = "A documentation generator for OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
