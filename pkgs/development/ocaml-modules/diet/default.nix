{ lib, buildDunePackage, fetchurl, ocaml, stdlib-shims, ounit }:

buildDunePackage rec {
  pname = "diet";
  version = "0.4";

  src = fetchurl {
    url =
      "https://github.com/mirage/ocaml-diet/releases/download/v${version}/diet-v${version}.tbz";
    sha256 = "96acac2e4fdedb5f47dd8ad2562e723d85ab59cd1bd85554df21ec907b071741";
  };

  minimalOCamlVersion = "4.03";

  propagatedBuildInputs = [ stdlib-shims ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit ];

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-diet";
    description = "Simple implementation of Discrete Interval Encoding Trees";
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
  };
}
