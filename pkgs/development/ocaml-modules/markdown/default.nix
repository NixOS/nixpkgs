{
  lib,
  buildDunePackage,
  fetchurl,
  batteries,
  tyxml,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "markdown";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/gildor478/ocaml-markdown/releases/download/v${finalAttrs.version}/markdown-v${finalAttrs.version}.tbz";
    hash = "sha256-nFdbdK0UIpqwiYGaNIoaj0UwI7/PHCDrxfxHNDYj3l4=";
  };

  propagatedBuildInputs = [
    batteries
    tyxml
  ];

  doCheck = true;

  checkInputs = [ ounit2 ];

  meta = {
    homepage = "https://github.com/gildor478/ocaml-markdown";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    description = "Markdown parser and printer";
  };

})
