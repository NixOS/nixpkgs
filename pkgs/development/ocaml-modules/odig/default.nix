{
  lib,
  fetchurl,
  buildTopkgPackage,
  cmdliner,
  odoc,
  b0,
}:

buildTopkgPackage rec {
  pname = "odig";
  version = "0.1.0";

  src = fetchurl {
    url = "https://erratique.ch/software/odig/releases/odig-${version}.tbz";
    hash = "sha256-uyiJXYKNGGb2FIRW0CDyB7QW9e4FI0+zVfkE7kNjtuE=";
  };

  buildInputs = [
    cmdliner
    odoc
    b0
  ];

  meta = {
    description = "Lookup documentation of installed OCaml packages";
    longDescription = ''
      odig is a command line tool to lookup documentation of installed OCaml
      packages. It shows package metadata, readmes, change logs, licenses,
      cross-referenced `odoc` API documentation and manuals.
    '';
    homepage = "https://erratique.ch/software/odig";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.Julow ];
  };
}
