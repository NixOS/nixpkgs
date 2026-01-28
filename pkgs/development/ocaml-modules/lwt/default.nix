{
  lib,
  fetchFromGitHub,
  libev,
  buildDunePackage,
  cppo,
  dune-configurator,
  ocplib-endian,
  ppxlib,
  version ? if lib.versionAtLeast ppxlib.version "0.36" then "6.0.0" else "5.9.1",
}:

buildDunePackage {
  pname = "lwt";
  inherit version;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "lwt";
    tag = version;
    hash =
      {
        "5.9.1" = "sha256-oPYLFugMTI3a+hmnwgUcoMgn5l88NP1Roq0agLhH/vI=";
        "6.0.0" = "sha256-TFR0LeOkk/6i6oJGETENhrtrcOhTWZdAABFkncf12sU=";
      }
      ."${version}";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    libev
    ocplib-endian
  ];

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "Cooperative threads library for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
