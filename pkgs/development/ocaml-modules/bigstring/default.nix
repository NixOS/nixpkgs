{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "bigstring";
  version = "0.2";

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-bigstring";
    rev = version;
    sha256 = "0ypdf29cmwmjm3djr5ygz8ls81dl41a4iz1xx5gbcdpbrdiapb77";
  };

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/c-cube/ocaml-bigstring";
    description = "Bigstring built on top of bigarrays, and convenient functions";
    license = licenses.bsd2;
    maintainers = [ maintainers.alexfmpe ];
  };
}
