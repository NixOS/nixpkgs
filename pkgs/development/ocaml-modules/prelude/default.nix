{
  lib,
  buildDunePackage,
  fetchzip,
}:

buildDunePackage rec {
  pname = "prelude";
  version = "0.5";

  minimalOCamlVersion = "4.13";

  # upstream git repo is misconfigured and cannot be cloned
  src = fetchzip {
    url = "https://git.zapashcanon.fr/zapashcanon/prelude/archive/${version}.tar.gz";
    hash = "sha256-lti+q1U/eEasAXo0O5YEu4iw7947V9bdvSHA0IEMS8M=";
  };

  doCheck = true;

  meta = {
    description = "Library to enforce good stdlib practices";
    homepage = "https://ocaml.org/p/prelude/";
    downloadPage = "https://git.zapashcanon.fr/zapashcanon/prelude";
    changelog = "https://git.zapashcanon.fr/zapashcanon/prelude/src/tag/${version}/CHANGES.md";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}
