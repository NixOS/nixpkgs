{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  camlp-streams,
  cppo,
  cryptokit,
  ocurl,
  yojson,
  ounit2,
}:

buildDunePackage rec {
  pname = "gapi-ocaml";
  version = "0.4.7";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uQJfrgF0oafURlamHslt9hX9MP4vFeVqDhuX7T/kjiY=";
  };

  nativeBuildInputs = [ cppo ];

  propagatedBuildInputs = [
    camlp-streams
    cryptokit
    ocurl
    yojson
  ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = {
    description = "OCaml client for google services";
    homepage = "https://github.com/astrada/gapi-ocaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bennofs ];
  };
}
