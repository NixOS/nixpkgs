{ lib, fetchurl, ppx_deriving, ppxfind, buildDunePackage }:

buildDunePackage rec {
  pname = "lens";
  version = "1.2.3";

  src = fetchurl {
    url = "https://github.com/pdonadeo/ocaml-lens/archive/v${version}.tar.gz";
    sha256 = "0mg4lfjp3c5fy68j822kbw4i1jz82msfwxxbb7jklga7jvfpcs95";
  };

  minimumOCamlVersion = "4.04.1";
  buildInputs = [ ppx_deriving ppxfind ];

  meta = with lib; {
    homepage = https://github.com/pdonadeo/ocaml-lens;
    description = "Functional lenses";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      kazcw
    ];
  };
}
