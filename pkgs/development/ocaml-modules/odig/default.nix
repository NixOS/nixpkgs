{ lib, stdenv, fetchurl, buildTopkgPackage, cmdliner, odoc, b0 }:

buildTopkgPackage rec {
  pname = "odig";
  version = "0.0.9";

  src = fetchurl {
    url = "${meta.homepage}/releases/odig-${version}.tbz";
    sha256 = "sha256-sYKvGYkxeF5FmrNQdOyMAtlsJqhlmUESi9SkPn/cjM4=";
  };

  buildInputs = [ cmdliner odoc b0 ];

  meta = with lib; {
    description = "Lookup documentation of installed OCaml packages";
    longDescription = ''
      odig is a command line tool to lookup documentation of installed OCaml
      packages. It shows package metadata, readmes, change logs, licenses,
      cross-referenced `odoc` API documentation and manuals.
    '';
    homepage = "https://erratique.ch/software/odig";
    license = licenses.isc;
    maintainers = [ maintainers.Julow ];
  };
}
