{ lib, fetchFromGitHub, buildDunePackage
, astring, cmdliner, cppo, fpath, result, tyxml
}:

buildDunePackage rec {
  pname = "odoc";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = version;
    sha256 = "0fqfyz48q7ss5bc4c5phmp4s3ka3vc08b8gfk8fvyryvb4bq27jm";
  };

  buildInputs = [ astring cmdliner cppo fpath result tyxml ];

  meta = {
    description = "A documentation generator for OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
