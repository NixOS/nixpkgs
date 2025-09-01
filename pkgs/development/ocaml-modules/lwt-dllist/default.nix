{
  lib,
  buildDunePackage,
  fetchurl,
  lwt,
  ocaml,
}:

buildDunePackage rec {
  pname = "lwt-dllist";
  version = "1.0.1";

  useDune2 = true;

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "e86ce75e40f00d51514cf8b2e71e5184c4cb5dae96136be24613406cfc0dba6e";
  };

  checkInputs = [
    lwt
  ];
  doCheck = lib.versionAtLeast ocaml.version "4.03";

  meta = with lib; {
    description = "Mutable doubly-linked list with Lwt iterators";
    homepage = "https://github.com/mirage/lwt-dllist";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
