{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "ocaml-version";
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/ocurrent/ocaml-version/releases/download/v${version}/ocaml-version-v${version}.tbz";
    sha256 = "sha256-rHuhagnY9yISdC85NpgPv667aYx7v2JRgq99ayw83l8=";
  };

  minimumOCamlVersion = "4.07";
  useDune2 = true;

  meta = with lib; {
    description = "Manipulate, parse and generate OCaml compiler version strings";
    homepage = "https://github.com/ocurrent/ocaml-version";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
