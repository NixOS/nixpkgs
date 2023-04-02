{ lib, stdenv, fetchFromGitHub, omake, ocaml, flex, bison }:

stdenv.mkDerivation rec {
  pname = "teyjus";
  version = "unstable-2019-07-26";

  src = fetchFromGitHub {
    owner = "teyjus";
    repo = "teyjus";
    rev = "e63f40aa9f1d0ea5e7bac41aae5e479c3616545c";
    sha256 = "sha256-gaAWKd5/DZrIPaaQzx9l0KtCMW9LPw17vvNPsnopZA0=";
  };

  patches = [
    ./fix-lex-to-flex.patch
  ];

  postPatch = ''
    sed -i "/TST/d" source/OMakefile
    rm -rf source/front/caml
  '';

  strictDeps = true;

  nativeBuildInputs = [ omake ocaml flex bison ];

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = "-I${ocaml}/include";

  buildPhase = "omake all";

  checkPhase = "omake check";

  installPhase = "mkdir -p $out/bin && cp tj* $out/bin";

  meta = with lib; {
    description = "An efficient implementation of the Lambda Prolog language";
    homepage = "https://github.com/teyjus/teyjus";
    license = lib.licenses.gpl3;
    maintainers = [ maintainers.bcdarwin ];
    platforms = platforms.unix;
  };
}
