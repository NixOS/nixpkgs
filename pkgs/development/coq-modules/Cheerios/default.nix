{ lib, mkCoqDerivation, coq, StructTact, version ? null }:

with lib; mkCoqDerivation {
  pname   = "cheerios";
  owner   = "uwplse";
  inherit version;
  defaultVersion = if versions.range "8.6" "8.16" coq.version then "20200201" else null;
  release."20200201".rev    = "9c7f66e57b91f706d70afa8ed99d64ed98ab367d";
  release."20200201".sha256 = "1h55s6lk47bk0lv5ralh81z55h799jbl9mhizmqwqzy57y8wqgs1";

  propagatedBuildInputs = [ StructTact ];
  preConfigure = ''
    if [ -f ./configure ]; then
      patchShebangs ./configure
    fi
  '';
}
