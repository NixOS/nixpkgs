{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wolfentext3d";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "AtomicPair";
    repo = "wolfentext3d";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4ZJbzDMuj8nGYqsD97p0B4q3J+Lm12rE8f//Mr2vbKk=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 wolfentext.rb $out/share/wolfentext3d/wolfentext.rb

    makeWrapper ${lib.getExe ruby} $out/bin/wolfentext3d \
    --add-flags "$out/share/wolfentext3d/wolfentext.rb"

    runHook postInstall
  '';

  meta = {
    description = "Wolfentext3D is a ASCII-art CLI game based on a classic game Wolfenstein";
    homepage = "https://github.com/AtomicPair/wolfentext3d";
    mainProgram = "wolfentext3d";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
