{ lib, fetchFromGitHub, buildDunePackage, ocaml, alcotest, bigstringaf }:

buildDunePackage rec {
  pname = "faraday";
  version = "0.7.2";

  useDune2 = true;

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "0gdysszzk6b6npic4nhpdnz2nbq7rma6aml0rbn113bfh0rmb36x";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ bigstringaf ];
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  meta = {
    description = "Serialization library built for speed and memory efficiency";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
