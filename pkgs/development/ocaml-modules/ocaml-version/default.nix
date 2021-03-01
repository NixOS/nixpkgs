{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {

  pname = "ocaml-version";
  version = "3.0.0";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/ocurrent/ocaml-version/releases/download/v${version}/ocaml-version-v${version}.tbz";
    sha256 = "15vk8sh50p3f2mbv8z7mqnx76cffri36f2krp25zkkwix8jg7ci4";
  };

  meta = {
    description = "Manipulate, parse and generate OCaml compiler version strings";
    homepage = "https://github.com/ocurrent/ocaml-version";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
