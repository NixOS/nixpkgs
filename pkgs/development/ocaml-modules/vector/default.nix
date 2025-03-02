{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "vector";
  version = "1.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/backtracking/vector/releases/download/${version}/vector-${version}.tbz";
    sha256 = "sha256:0hb6prpada4c5z07sxf5ayj5xbahsnwall15vaqdwdyfjgbd24pj";
  };

  doCheck = true;

  meta = {
    description = "Resizable arrays for OCaml";
    license = lib.licenses.lgpl2Only;
    homepage = "https://github.com/backtracking/vector";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
