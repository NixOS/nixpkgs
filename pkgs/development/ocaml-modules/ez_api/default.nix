{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  json-data-encoding,
  ezjsonm,
  uuidm,
}:

buildDunePackage (finalAttrs: {
  pname = "ez_api";
  version = "3.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ez_api";
    tag = finalAttrs.version;
    hash = "sha256-Z/mtgVzwJ118QLF3p6qy5jtYDstX2zUj2AlS+QVugDQ=";
  };

  propagatedBuildInputs = [
    json-data-encoding
    ezjsonm
    uuidm
  ];

  doCheck = true;

  meta = {
    description = "Easily build clients and servers on top of a common REST API, automatically derived from OCaml types";
    homepage = "https://github.com/OCamlPro/ez_api";
    license = lib.licenses.WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException;
    maintainers = with lib.maintainers; [ sempiternal-aurora ];
    mainProgram = "ezserve";
  };
})
