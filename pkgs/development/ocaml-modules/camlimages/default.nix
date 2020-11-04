{ lib, fetchFromGitLab, buildDunePackage, dune-configurator, cppo, lablgtk, stdio }:

buildDunePackage rec {
  pname = "camlimages";
  version = "5.0.3";

  useDune2 = true;

  minimumOCamlVersion = "4.07";

  src = fetchFromGitLab {
    owner = "camlspotter";
    repo = pname;
    rev = version;
    sha256 = "1ng9pkvrzlibfyf97iqvmbsqcykz8v1ln106xhq9nigih5i68zyd";
  };

  buildInputs = [ dune-configurator cppo lablgtk stdio ];

  meta = with lib; {
    branch = "5.0";
    inherit (src.meta) homepage;
    description = "OCaml image processing library";
    license = licenses.lgpl2;
    maintainers = [ maintainers.vbgl maintainers.mt-caret ];
  };
}
