{ stdenv, fetchFromGitHub, coq }:

let param =
  {
      version = "20181102";
      rev = "82a85b7ec07e71fa6b30cfc05f6a7bfb09ef2510";
      sha256 = "08zry20flgj7qq37xk32kzmg4fg6d4wi9m7pf9aph8fd3j2a0b5v";
  };
in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-StructTact-${param.version}";

  src = fetchFromGitHub {
    owner = "uwplse";
    repo = "StructTact";
    inherit (param) rev sha256;
  };

  buildInputs = [ coq ];

  enableParallelBuilding = true;

  preConfigure = "patchShebangs ./configure";

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  passthru = {
    compatibleCoqVersions = v: stdenv.lib.versionAtLeast v "8.5";
 };
}
