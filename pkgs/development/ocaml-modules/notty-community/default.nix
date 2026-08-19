{
  lib,
  fetchurl,
  buildDunePackage,
  cppo,
  uutf,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "notty-community";
  version = "0.2.4";

  src = fetchurl {
    url = "https://github.com/ocaml-community/notty-community/releases/download/v${finalAttrs.version}/notty-community-${finalAttrs.version}.tar.gz";
    hash = "sha256-FrA3wGX4lQZtrwXked1K/8LLvXel8xYIZ57gEmxX/d8=";
  };

  nativeBuildInputs = [ cppo ];

  propagatedBuildInputs = [
    lwt
    uutf
  ];

  doCheck = true;

  meta = {
    description = "A declarative terminal library for OCaml";
    homepage = "https://github.com/ocaml-community/notty-community";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
