{ lib, fetchFromGitHub, buildDunePackage
, astring, cmdliner, cppo, fpath, result, tyxml
}:

buildDunePackage rec {
  pname = "odoc";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = version;
    sha256 = "0rvhx139jx6wmlfz355mja6mk03x4swq1xxvk5ky6jzhalq3cf5i";
  };

  buildInputs = [ astring cmdliner cppo fpath result tyxml ];

  meta = {
    description = "A documentation generator for OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
