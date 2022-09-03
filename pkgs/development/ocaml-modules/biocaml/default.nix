{ lib, buildDunePackage, fetchFromGitHub, fetchpatch
, ounit, async, base64, camlzip, cfstream
, core, ppx_jane, ppx_sexp_conv, rresult, uri, xmlm }:

buildDunePackage rec {
  pname = "biocaml";
  version = "0.11.2";

  minimalOCamlVersion = "4.11";

  src = fetchFromGitHub {
    owner = "biocaml";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "01yw12yixs45ya1scpb9jy2f7dw1mbj7741xib2xpq3kkc1hc21s";
  };

  patches = fetchpatch {
    url = "https://github.com/biocaml/biocaml/commit/3ef74d0eb4bb48d2fb7dd8b66fb3ad8fe0aa4d78.patch";
    sha256 = "0rcvf8gwq7sz15mghl9ing722rl2zpnqif9dfxrnpdxiv0rl0731";
  };

  buildInputs = [ ppx_jane ppx_sexp_conv ];
  checkInputs = [ ounit ];
  propagatedBuildInputs = [ async base64 camlzip cfstream core rresult uri xmlm ];

  meta = with lib; {
    description = "Bioinformatics library for Ocaml";
    homepage = "http://${pname}.org";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.gpl2;
  };
}
