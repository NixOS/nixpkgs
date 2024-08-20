{ lib, fetchFromGitHub, libev, buildDunePackage
, cppo, dune-configurator, ocplib-endian
}:

buildDunePackage rec {
  pname = "lwt";
  version = "5.7.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "lwt";
    rev = version;
    hash = "sha256-o0wPK6dPdnsr/LzwcSwbIGcL85wkDjdFuEcAxuS/UEs=";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libev ocplib-endian ];

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "Cooperative threads library for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
