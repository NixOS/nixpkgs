{ stdenv, fetchurl }:
let
  version = "0.9.11b0";
in
stdenv.mkDerivation {
  pname = "Linux-Docs.py";
  inherit version;
  src = fetchurl {
    url = "https://github.com/Aermoss/PySDL3/releases/download/v${version}/Linux-Docs.py";
    hash = "sha256-ldx6r0KKNl1mkohTkaEG4rawf4VjHeJvNUdPkmrAkYA=";
  };
}
