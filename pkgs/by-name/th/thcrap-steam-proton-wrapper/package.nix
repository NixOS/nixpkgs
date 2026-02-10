{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  subversion,
  zenity,
}:
stdenv.mkDerivation {
  pname = "thcrap-proton";
  version = "0-unstable-2024-04-03";

  src = fetchFromGitHub {
    owner = "tactikauan";
    repo = "thcrap-steam-proton-wrapper";
    rev = "2b636c3f5f1ce1b9b41f731aa9397aa68d2ce66b";
    hash = "sha256-J2O8F75NMdsxSaNVr8zLf+vLEJE6CHqWQIIscuuJZ3o=";
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
          zenity
        ]
      }
  '';

  meta = {
    description = "Wrapper script for launching the official Touhou games on Steam with patches through Proton on GNU/Linux";
    homepage = "https://github.com/tactikauan/thcrap-steam-proton-wrapper";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ashuramaruzxc ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "thcrap_proton";
  };
}
