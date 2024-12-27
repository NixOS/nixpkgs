{
  lib,
  stdenv,
  fetchFromGitea,
  xorg,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "sxcs";
  version = "1.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "NRK";
    repo = "sxcs";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-rYmbbdZjeLCvGvNocI3+KVU2KBkYvRisayTyScTRay8=";
  };

  buildInputs = [
    xorg.libX11
    xorg.libXcursor
  ];
  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild
    ${stdenv.cc.targetPrefix}cc -o sxcs sxcs.c -O3 -s -l X11 -l Xcursor
    runHook postBuild
  '';

  outputs = [
    "out"
    "man"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 sxcs -t $out/bin
    installManPage sxcs.1

    runHook postInstall
  '';

  meta = {
    description = "Minimal X11 Color Picker and Magnifier";
    homepage = "https://codeberg.org/NRK/sxcs";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux;
  };
})
