{ buildDunePackage
, fetchzip
, ppx_expect
, lib
}:

buildDunePackage rec {
  pname = "pp";
  version = "1.1.2";

  src = fetchzip {
    url = "https://github.com/ocaml-dune/pp/releases/download/${version}/pp-${version}.tbz";
    sha256 = "1l1im054pxrkj7zk8m6yj4qfdpxkajpjfvy818ggf0j4nxkaihc5";
  };

  useDune2 = true;
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
