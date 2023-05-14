{ lib, fetchFromGitHub, libev, buildDunePackage
, ocaml, cppo, dune-configurator, ocplib-endian
}:

buildDunePackage rec {
  pname = "lwt";
  version = "5.6.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "lwt";
    rev = version;
    sha256 = "sha256-XstKs0tMwliCyXnP0Vzi5WC27HKJGnATUYtbbQmH1TE=";
  };

  postPatch = lib.optionalString (lib.versionAtLeast ocaml.version "5.0") ''
    substituteInPlace src/unix/dune \
      --replace "libraries bigarray lwt" "libraries lwt"
  '';

  nativeBuildInputs = [ cppo ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libev ocplib-endian ];

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
