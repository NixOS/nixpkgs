{ stdenv, fetchurl }:
let
  version = "0.9.11b0";
in
stdenv.mkDerivation {
  pname = "Darwin-Docs.py";
  inherit version;
  src = fetchurl {
    url = "https://github.com/Aermoss/PySDL3/releases/download/v${version}/Darwin-Docs.py";
    hash = "sha256-ga0ebb9zIPI5+Qza8APs0kbCxUIxqCmXRO/R8uWASOg=";
  };
}
