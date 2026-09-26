{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "torctl";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "BlackArch";
    repo = "torctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rTJR+9pbK/sWMqdHyIqJgASgCGtGtpUPoHmYZJ7COFQ=";
  };

  installPhase = ''
    mkdir -p $out/{bin,etc/{systemd,bash_completion.d}}
    cp -R torctl $out/bin
    cp -R bash-completion $out/etc/bash_completion.d/
    cp -R service $out/etc/systemd/
  '';

  meta = {
    description = "Script to redirect all traffic through tor network including dns queries for anonymizing entire system";
    homepage = "https://github.com/BlackArch/torctl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "torctl";
    platforms = lib.platforms.all;
  };
})
