{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  version = "2.1.2";
  pname = "opam-file-format";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = version;
    sha256 = "19xppn2s3yjid8jc1wh8gdf5mgmlpzby2cf2slmnbyrgln3vj6i2";
  };

  meta = {
    description = "Parser and printer for the opam file syntax";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
