{
  lib,
  fetchurl,
  buildDunePackage,
  testo,
  testo-diff,
  fpath,
  re,
}:

buildDunePackage {
  pname = "testo-util";
  inherit (testo) version src;

  propagatedBuildInputs = [
    fpath
    re
    testo-diff
  ];

  meta = testo.meta // {
    description = "Modules shared by testo, testo-lwt, etc";
  };
}
