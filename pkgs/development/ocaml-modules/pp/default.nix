{
  buildDunePackage,
  fetchurl,
  ppx_expect,
  lib,
}:

buildDunePackage rec {
  pname = "pp";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/pp/releases/download/${version}/pp-${version}.tbz";
    hash = "sha256-pegiVzxVr7Qtsp7FbqzR8qzY9lzy3yh44pHeN0zmkJw=";
  };

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  checkInputs = [ ppx_expect ];
  doCheck = true;

  meta = with lib; {
    description = "A an alternative pretty printing library to the Format module of the OCaml standard library";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
