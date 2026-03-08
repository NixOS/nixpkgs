{
  lib,
  ocaml,
  buildDunePackage,
  fetchurl,
  mdx,
}:

buildDunePackage (finalAttrs: {
  pname = "colors";
  version = "0.0.1";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/leostera/colors/releases/download/${finalAttrs.version}/colors-${finalAttrs.version}.tbz";
    hash = "sha256-fY1j9FODVnifwsI8qkKm0QSmssgWqYFXJ7y8o7/KmEY=";
  };

  doCheck = lib.versionAtLeast ocaml.version "5.1";

  checkInputs = [
    mdx
  ];

  nativeCheckInputs = [
    mdx.bin
  ];

  meta = {
    description = "Pure OCaml library for manipulating colors across color spaces";
    homepage = "https://github.com/leostera/colors";
    changelog = "https://github.com/leostera/colors/blob/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
