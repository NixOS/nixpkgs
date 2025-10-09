{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "metadata";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-metadata";
    tag = "v${version}";
    sha256 = "sha256-CsmKk14jk/PuTibEmlFr/QZbmDIkLJ5QJSIZQXLRmGw=";
  };

  minimalOCamlVersion = "4.14";

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-metadata";
    description = "Library to read metadata from files in various formats";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
