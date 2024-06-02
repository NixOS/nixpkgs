{ lib
, buildDunePackage
, fetchurl
, mdx
}:

buildDunePackage rec {
  pname = "colors";
  version = "0.0.1";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/leostera/colors/releases/download/${version}/colors-${version}.tbz";
    hash = "sha256-fY1j9FODVnifwsI8qkKm0QSmssgWqYFXJ7y8o7/KmEY=";
  };

  doCheck = true;

  checkInputs = [
    mdx
  ];

  nativeCheckInputs = [
    mdx.bin
  ];

  meta = {
    description = "A pure OCaml library for manipulating colors across color spaces";
    homepage = "https://github.com/leostera/colors";
    changelog = "https://github.com/leostera/colors/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
