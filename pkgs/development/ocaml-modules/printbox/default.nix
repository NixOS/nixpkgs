{ lib, fetchFromGitHub, buildDunePackage, uucp, uutf }:

buildDunePackage rec {
  pname = "printbox";
  version = "0.4";

  minimumOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = version;
    sha256 = "0bq2v37v144i00h1zwyqhkfycxailr245n97yff0f7qnidxprix0";
  };

  checkInputs = lib.optionals doCheck [ uucp uutf ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/c-cube/printbox/";
    description = "Allows to print nested boxes, lists, arrays, tables in several formats";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
  };
}
