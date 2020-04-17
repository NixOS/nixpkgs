{ lib, fetchurl, buildDunePackage, dune-configurator, libX11 }:

buildDunePackage rec {

  pname = "graphics";
  version = "5.1.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocaml/graphics/releases/download/${version}/graphics-${version}.tbz";
    sha256 = "16z997mp0ccilaqqvmz3wp7vx0ghaf4ik9qklgd4piklcl1yv5n5";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libX11 ];

  meta = {
    homepage = "https://github.com/ocaml/graphics";
    description = "A set of portable drawing primitives";
    license = lib.licenses.lgpl2;
  };
}
