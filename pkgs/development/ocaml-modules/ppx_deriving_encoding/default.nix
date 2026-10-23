{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  ppxlib,
  json-data-encoding,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_deriving_encoding";
  version = "0.4.2";

  minimalOCamlVersion = "4.13";
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "o-labs";
    repo = "ppx_deriving_encoding";
    tag = finalAttrs.version;
    hash = "sha256-EJTc5nYvKXkYlfFyTKRm7z/H9EKWtHZFmhyjYCUAMUs=";
  };

  propagatedBuildInputs = [
    ppxlib
    json-data-encoding
  ];

  meta = {
    description = "Ppx deriver for json_encoding";
    homepage = "https://gitlab.com/o-labs/ppx_deriving_encoding";
    license = lib.licenses.WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
