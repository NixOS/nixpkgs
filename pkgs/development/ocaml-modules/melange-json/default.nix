{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  yojson,
  melange,
  ppxlib,
}:

buildDunePackage rec {
  pname = "melange-json";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "melange-community";
    repo = "melange-json";
    tag = version;
    hash = "sha256-vgcvPRc2vEHE1AtHyttvs1T0LcoeTOFfmPUCz95goT0=";
  };

  nativeBuildInputs = [ melange ];
  buildInputs = [
    melange
    yojson
    ppxlib
  ];
  meta = {
    description = "Compositional JSON encode/decode library and PPX for Melange and OCaml";
    homepage = "https://github.com/melange-community/melange-json";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.GirardR1006 ];
  };
}
