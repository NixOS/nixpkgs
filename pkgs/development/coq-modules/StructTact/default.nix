{ stdenv, fetchFromGitHub, coq, mathcomp }:

let params =
  {
    "8.5" = {
      version = "20181102";
      rev = "82a85b7ec07e71fa6b30cfc05f6a7bfb09ef2510";
      sha256 = "08zry20flgj7qq37xk32kzmg4fg6d4wi9m7pf9aph8fd3j2a0b5v";
    };

    "8.6" = {
      version = "20181102";
      rev = "82a85b7ec07e71fa6b30cfc05f6a7bfb09ef2510";
      sha256 = "08zry20flgj7qq37xk32kzmg4fg6d4wi9m7pf9aph8fd3j2a0b5v";
    };

    "8.7" = {
      version = "20181102";
      rev = "82a85b7ec07e71fa6b30cfc05f6a7bfb09ef2510";
      sha256 = "08zry20flgj7qq37xk32kzmg4fg6d4wi9m7pf9aph8fd3j2a0b5v";
    };

    "8.8" = {
      version = "20181102";
      rev = "82a85b7ec07e71fa6b30cfc05f6a7bfb09ef2510";
      sha256 = "08zry20flgj7qq37xk32kzmg4fg6d4wi9m7pf9aph8fd3j2a0b5v";
    };

    "8.9" = {
      version = "20181102";
      rev = "82a85b7ec07e71fa6b30cfc05f6a7bfb09ef2510";
      sha256 = "08zry20flgj7qq37xk32kzmg4fg6d4wi9m7pf9aph8fd3j2a0b5v";
    };
  };
  param = params."${coq.coq-version}";
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-StructTact-${param.version}";

  src = fetchFromGitHub {
    owner = "uwplse";
    repo = "StructTact";
    inherit (param) rev sha256;
  };

  buildInputs = [
    coq coq.ocaml coq.camlp5 coq.findlib
  ];
  enableParallelBuilding = true;

  buildPhase = "make -j$NIX_BUILD_CORES";
  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" "8.9" ];
 };
}
