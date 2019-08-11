{ stdenv, fetchFromGitHub, coq, Cheerios, InfSeqExt, ssreflect }:

let param =
  if stdenv.lib.versionAtLeast coq.coq-version "8.7" then
  {
      version = "20190202";
      rev = "bc193be9ea8485add7646a0f72e2aa76a9c7e01f";
      sha256 = "1adkwxnmc9qfah2bya0hpd2vzkmk1y212z4n7fcmvr1a85ykgd7z";
  } else {
      version = "20181102";
      rev = "25b79cf1be5527ab8dc1b8314fcee93e76a2e564";
      sha256 = "1vw47c37k5vaa8vbr6ryqy8riagngwcrfmb3rai37yi9xhdqg55z";
  };
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-verdi-${param.version}";

  src = fetchFromGitHub {
    owner = "uwplse";
    repo = "verdi";
    inherit (param) rev sha256;
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ Cheerios InfSeqExt ssreflect ];

  enableParallelBuilding = true;

  preConfigure = "patchShebangs ./configure";

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" "8.9" ];
 };
}
