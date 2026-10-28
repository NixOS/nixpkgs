{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "csv";
  version = "2.4";

  src = fetchurl {
    url = "https://github.com/Chris00/ocaml-csv/releases/download/${finalAttrs.version}/csv-${finalAttrs.version}.tbz";
    hash = "sha256-E/7EgXfyZYxMYu3wT17dBVli+/KrtMPjctJo3SqyqY4=";
  };

  preConfigure = ''
    substituteInPlace src/dune --replace '(libraries bytes)' ""
  '';

  duneVersion = "3";

  meta = {
    description = "Pure OCaml library to read and write CSV files";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/Chris00/ocaml-csv";
  };
})
