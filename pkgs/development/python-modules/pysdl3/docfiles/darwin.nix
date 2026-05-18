{ stdenv, fetchurl }:
let
  version = "0.9.11b1";
in
stdenv.mkDerivation {
  pname = "Darwin-Docs.py";
  inherit version;
  src = fetchurl {
    url = "https://github.com/Aermoss/PySDL3/releases/download/v${version}/Darwin-Docs.py";
    hash = "sha256-gumVIn/st/mgdPpQA/BLZD0sI5qLf1EJRQ90rKLXjvQ=";
  };
}
