{ stdenv, fetchFromGitHub, coq, StructTact }:

let param =
  {
      version = "20200201";
      rev = "9c7f66e57b91f706d70afa8ed99d64ed98ab367d";
      sha256 = "1h55s6lk47bk0lv5ralh81z55h799jbl9mhizmqwqzy57y8wqgs1";
  };
in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-Cheerios-${param.version}";

  src = fetchFromGitHub {
    owner = "uwplse";
    repo = "cheerios";
    inherit (param) rev sha256;
  };

  buildInputs = [ coq ];

  propagatedBuildInputs = [ StructTact ];
  enableParallelBuilding = true;

  preConfigure = "patchShebangs ./configure";

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" "8.9" "8.10" "8.11" ];
 };
}
