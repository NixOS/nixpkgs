{ lib, fetchzip, ppx_deriving, ppxfind, buildDunePackage }:

buildDunePackage rec {
  pname = "lens";
  version = "1.2.3";

  src = fetchzip {
    url = "https://github.com/pdonadeo/ocaml-lens/archive/v${version}.tar.gz";
    sha256 = "09k2vhzysx91syjhgv6w1shc9mgzi0l4bhwpx1g5pi4r4ghjp07y";
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
