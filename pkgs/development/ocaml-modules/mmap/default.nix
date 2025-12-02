{
  lib,
  buildDunePackage,
  fetchurl,
  bigarray-compat,
}:

buildDunePackage rec {
  pname = "mmap";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/mirage/mmap/releases/download/v${version}/mmap-${version}.tbz";
    hash = "sha256-FgKoq8jiMvqUdxpS5UDleAtAwvJ2Lu5q+9koZQIRbds=";
  };

  propagatedBuildInputs = [ bigarray-compat ];

  meta = {
    homepage = "https://github.com/mirage/mmap";
    description = "Function for mapping files in memory";
    longDescription = ''
      This project provides a Mmap.map_file functions for mapping files in memory.
    '';
    changelog = "https://raw.githubusercontent.com/mirage/mmap/refs/tags/v${version}/CHANGES.md";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
