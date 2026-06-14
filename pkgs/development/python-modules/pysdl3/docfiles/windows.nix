{ stdenv, fetchurl }:
let
  version = "0.9.11b1";
in
stdenv.mkDerivation {
  pname = "Windows-Docs.py";
  inherit version;
  src = fetchurl {
    url = "https://github.com/Aermoss/PySDL3/releases/download/v${version}/Windows-Docs.py";
    hash = "sha256-55Ti6HUzlptSf9ozaz0kmYMz+6EAcOcnZ0R64rZYISY=";
  };
}
