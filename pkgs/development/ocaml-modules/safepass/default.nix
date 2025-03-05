{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "safepass";
  version = "3.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "darioteixeira";
    repo = "ocaml-safepass";
    rev = "v${version}";
    sha256 = "1cwslwdb1774lfmhcclj9kymvidbcpjx1vp16jnjirqdqgl4zs5q";
  };

  meta = {
    inherit (src.meta) homepage;
    description = "OCaml library offering facilities for the safe storage of user passwords";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ vbgl ];
  };

}
