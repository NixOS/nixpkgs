{ lib, fetchurl, buildDunePackage, dune-configurator, libX11 }:

buildDunePackage rec {

  pname = "graphics";
  version = "5.1.2";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocaml/graphics/releases/download/${version}/graphics-${version}.tbz";
    sha256 = "sha256-QA/YHSPxy0FGuWl5NCwkeXHdVPWHn/0vgOx80CEuMtQ=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libX11 ];

  meta = {
    homepage = "https://github.com/ocaml/graphics";
    description = "A set of portable drawing primitives";
    license = lib.licenses.lgpl2;
  };
}
