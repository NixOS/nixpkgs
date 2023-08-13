{ lib, mkCoqDerivation, coq, StructTact, version ? null }:

mkCoqDerivation {
  pname   = "cheerios";
  owner   = "uwplse";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.version [
    { case = range "8.14" "8.17"; out = "20230107"; }
    { case = range "8.6"  "8.16"; out = "20200201"; }
  ] null;
  release."20230107".rev    = "bad8ad2476e14df6b5a819b7aaddc27a7c53fb69";
  release."20230107".sha256 = "sha256-G7a+6h4VDk7seKvFr6wy7vYqYmhUje78TYCj98wXrr8=";
  release."20200201".rev    = "9c7f66e57b91f706d70afa8ed99d64ed98ab367d";
  release."20200201".sha256 = "1h55s6lk47bk0lv5ralh81z55h799jbl9mhizmqwqzy57y8wqgs1";

  propagatedBuildInputs = [ StructTact ];
  preConfigure = ''
    if [ -f ./configure ]; then
      patchShebangs ./configure
    fi
  '';
}
