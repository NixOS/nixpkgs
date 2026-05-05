{ stdenv, fetchurl }:
let
  version = "0.9.11b0";
in
stdenv.mkDerivation {
  pname = "Windows-Docs.py";
  inherit version;
  src = fetchurl {
    url = "https://github.com/Aermoss/PySDL3/releases/download/v${version}/Windows-Docs.py";
    hash = "sha256-bBwETA9/ph0zXVNad9zMkQvfq1MmFJ08tCV+mUPwlXQ=";
  };
}
