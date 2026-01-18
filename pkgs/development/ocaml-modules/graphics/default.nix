{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  dune-configurator,
  libX11,
  libXft,
}:

buildDunePackage (finalAttrs: {
  pname = "graphics";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "graphics";
    tag = finalAttrs.version;
    hash = "sha256-0lpeZW1U//J5lH04x2ReBeug4s79KCyb5QYaiVgcBZI=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    libX11
    libXft
  ];

  meta = {
    homepage = "https://github.com/ocaml/graphics";
    description = "Set of portable drawing primitives";
    license = lib.licenses.lgpl2;
  };
})
