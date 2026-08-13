{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  subversion,
}:
stdenv.mkDerivation {
  pname = "thcrap-proton";
  version = "0-unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "nerusuki";
    repo = "thcrap-steam-proton-wrapper";
    rev = "a5edfe44ead2df2e6bca54bd738ae0dc3284e679";
    hash = "sha256-4RTVfcwlYW+KPyPIon0X1d4SPsF6cFkRSXBfe4yzAyQ=";
  };

  buildInputs = [ subversion ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp thcrap_proton $out/bin/thcrap_proton

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/thcrap_proton \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          subversion
        ]
      }
  '';

  meta = {
    description = "Wrapper script for launching the official Touhou games on Steam with patches through Proton on GNU/Linux";
    homepage = "https://github.com/nerusuki/thcrap-steam-proton-wrapper";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ashuramaruzxc ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "thcrap_proton";
  };
}
