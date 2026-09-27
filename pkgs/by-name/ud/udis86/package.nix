{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  python3,
}:

stdenv.mkDerivation {
  pname = "udis86";
  version = "1.7.2-unstable-2022-10-13";

  src = fetchFromGitHub {
    owner = "canihavesomecoffee";
    repo = "udis86";
    rev = "5336633af70f3917760a6d441ff02d93477b0c86";
    hash = "sha256-HifdUQPGsKQKQprByeIznvRLONdOXeolOsU5nkwIv3g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    python3
  ];

  configureFlags = [
    "--enable-shared"
  ];

  outputs = [
    "bin"
    "out"
    "dev"
    "lib"
  ];

  meta = {
    homepage = "https://github.com/canihavesomecoffee/udis86";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ timor ];
    mainProgram = "udcli";
    description = ''
      Easy-to-use, minimalistic x86 disassembler library (libudis86)
    '';
    platforms = lib.platforms.all;
  };
}
