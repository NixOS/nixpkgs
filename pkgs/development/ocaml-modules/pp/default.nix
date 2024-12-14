{
  lib,
  buildDunePackage,
  fetchurl,
  ppx_expect,
  version ? "2.0.0",
}:

buildDunePackage rec {
  pname = "pp";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ocaml-dune/pp/releases/download/${version}/pp-${version}.tbz";
    hash =
      {
        "2.0.0" = "sha256-hlE1FRiwkrSi3vTggXHCdhUvkvtqhKixm2uSnM20RBk=";
        "1.2.0" = "sha256-pegiVzxVr7Qtsp7FbqzR8qzY9lzy3yh44pHeN0zmkJw=";
      }
      ."${version}";
  };

  minimalOCamlVersion = "4.08";

  checkInputs = [ ppx_expect ];
  doCheck = true;

  meta = with lib; {
    description = "A an alternative pretty printing library to the Format module of the OCaml standard library";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
