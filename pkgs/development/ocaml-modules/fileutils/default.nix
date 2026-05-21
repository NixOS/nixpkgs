{
  lib,
  fetchurl,
  ocaml,
  buildDunePackage,
  seq,
  stdlib-shims,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "fileutils";
  version = "0.6.6";

  src = fetchurl {
    url = "https://github.com/gildor478/ocaml-fileutils/releases/download/v${finalAttrs.version}/fileutils-${finalAttrs.version}.tbz";
    hash = "sha256-eW1XkeK/ezv/IAz1BXp6GHhDnrzXTtDxCIz4Z1bVK+Y=";
  };

  minimalOCamlVersion = "4.14";

  propagatedBuildInputs = [
    seq
    stdlib-shims
  ];

  checkInputs = [
    ounit2
  ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "OCaml API to manipulate real files (POSIX like) and filenames";
    homepage = "https://github.com/gildor478/ocaml-fileutils";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ vbgl ];
  };
})
