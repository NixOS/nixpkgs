{ lib, fetchFromGitHub, buildDunePackage
, astring, cmdliner, cppo, fpath, result, tyxml
}:

buildDunePackage rec {
  pname = "odoc";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = version;
    sha256 = "14ilq2glcvda8mfhj27jqqwx3392q8ssp9bq9agz7k1k6ilp9dai";
  };

  buildInputs = [ astring cmdliner cppo fpath result tyxml ];

  meta = {
    description = "A documentation generator for OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
