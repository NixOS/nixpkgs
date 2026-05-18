{ stdenv, fetchurl }:
let
  version = "0.9.11b1";
in
stdenv.mkDerivation {
  pname = "Linux-Docs.py";
  inherit version;
  src = fetchurl {
    url = "https://github.com/Aermoss/PySDL3/releases/download/v${version}/Linux-Docs.py";
    hash = "sha256-7Uc1kfbfizpRmAr5h3rpTX565wvbZfbbbYcJh9s96DY=";
  };
}
