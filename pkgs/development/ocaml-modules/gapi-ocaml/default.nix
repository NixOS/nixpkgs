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

buildDunePackage (finalAttrs: {
  pname = "gapi-ocaml";
  version = if lib.versionAtLeast cryptokit.version "1.21" then "0.4.9" else "0.4.7";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "gapi-ocaml";
    tag = "v${finalAttrs.version}";
    hash =
      {
        "0.4.7" = "sha256-uQJfrgF0oafURlamHslt9hX9MP4vFeVqDhuX7T/kjiY=";
        "0.4.9" = "sha256-UWoWWpCAKCNEwEFO4UBXrTO49QyxLXrulDHX6dGr0z4=";
      }
      ."${finalAttrs.version}";
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
})
