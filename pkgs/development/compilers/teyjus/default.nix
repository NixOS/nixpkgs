<<<<<<< HEAD
{ lib, fetchFromGitHub, buildDunePackage, flex, bison }:

buildDunePackage rec {
  pname = "teyjus";
  version = "2.1.1";
=======
{ lib, stdenv, fetchFromGitHub, omake, ocaml, flex, bison }:

stdenv.mkDerivation rec {
  pname = "teyjus";
  version = "unstable-2019-07-26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "teyjus";
    repo = "teyjus";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-N4XKDd0NFr501PYUdb7PM2sWh0uD1/SUFXoMr10f064=";
  };

  strictDeps = true;

  nativeBuildInputs = [ flex bison ];

  hardeningDisable = [ "format" ];

  doCheck = true;
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "An efficient implementation of the Lambda Prolog language";
    homepage = "https://github.com/teyjus/teyjus";
<<<<<<< HEAD
    changelog = "https://github.com/teyjus/teyjus/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.gpl3;
    maintainers = [ maintainers.bcdarwin ];
    platforms = platforms.unix;
  };
}
