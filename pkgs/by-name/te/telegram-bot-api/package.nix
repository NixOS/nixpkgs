{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gperf,
  openssl,
  zlib,
  versionCheckHook,
}:

stdenv.mkDerivation {
  pname = "telegram-bot-api";
  version = "8.2";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "telegram-bot-api";
    rev = "fa6706fc8f6e22b3c25b512ede6474613f32b32b";
    hash = "sha256-0ra1sL121ksUIhpV738tL3y1gu1csMf0rK95G8ElMuo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    gperf
  ];

  buildInputs = [
    openssl
    zlib
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "Telegram Bot API server";
    homepage = "https://github.com/tdlib/telegram-bot-api";
    license = licenses.boost;
    maintainers = with maintainers; [
      Anillc
      Forden
      nartsiss
    ];
    platforms = platforms.all;
    mainProgram = "telegram-bot-api";
  };
}
