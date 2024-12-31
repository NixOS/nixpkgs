{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  rename,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ubuntu-sans-mono";
  version = "1.006";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "Ubuntu-Sans-Mono-fonts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EFZZnMZTQHo2Tr9/rtb7C5gAlQ/0uYT+MQ1gKkqQ5hE=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype/ubuntu-sans fonts/variable/*
    ${rename}/bin/rename 's/\[.*\]//' $out/share/fonts/truetype/ubuntu-sans/*

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Ubuntu Font Family (Mono)";
    longDescription = "The Ubuntu Font Family are a set of matching libre/open fonts.
    The fonts were originally developed in 2010–2011,
    further expanded and improved in 2015,
    and expanded again in 2022–2023 when variable fonts were added.";
    homepage = "https://design.ubuntu.com/font";
    changelog = "https://github.com/canonical/Ubuntu-Sans-Mono-fonts/blob/${finalAttrs.src.rev}/FONTLOG.txt";
    license = licenses.ufl;
    platforms = platforms.all;
    maintainers = with maintainers; [ jopejoe1 ];
  };
})
