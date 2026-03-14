{
  lib,
  fetchFromGitHub,
  libev,
  buildDunePackage,
  cppo,
  dune-configurator,
  ocplib-endian,
  ppxlib,
  version ? if lib.versionAtLeast ppxlib.version "0.36" then "6.1.0" else "5.9.1",
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
        "6.1.0" = "sha256-ILW3GbYZU3g2wqHJRIdQVWXGJGgrUo7YNhOo8zBhD8E=";
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
