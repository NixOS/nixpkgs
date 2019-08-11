{ lib, fetchzip, buildDunePackage, configurator, cppo, lablgtk }:

buildDunePackage rec {
  pname = "camlimages";
  version = "5.0.1";

  src = fetchzip {
    url = "https://bitbucket.org/camlspotter/${pname}/get/${version}.tar.gz";
    sha256 = "1figrgzsdrrxzfza0bhz0225g1rwawdf5x2m9lw2kzrdb815khs5";
  };

  buildInputs = [ configurator cppo lablgtk ];

  meta = with lib; {
    branch = "5.0";
    homepage = https://bitbucket.org/camlspotter/camlimages;
    description = "OCaml image processing library";
    license = licenses.gpl2;
    maintainers = [ maintainers.vbgl maintainers.mt-caret ];
  };
}
