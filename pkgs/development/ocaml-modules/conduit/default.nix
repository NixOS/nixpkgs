{ stdenv, fetchurl, buildDunePackage
, stdlib-shims, ipaddr, domain-name
, rresult, alcotest
}:

buildDunePackage rec {
  pname = "conduit";
  version = "3.0.0";

  minimumOCamlVersion = "4.07";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v${version}/conduit-v${version}.tbz";
    sha256 = "1fyd6d00arf8pisddia7sk6jlhdrp0d37lh9zjsj5ip892812l4b";
  };

  buildInputs = [ stdlib-shims ];
  propagatedBuildInputs = [ ipaddr domain-name ];

  doCheck = true;
  checkInputs = [ rresult alcotest ];

  meta = {
    description = "A network connection establishment library";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ alexfmpe vbgl ];
    homepage = "https://github.com/mirage/ocaml-conduit";
  };
}
