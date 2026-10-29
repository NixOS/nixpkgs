{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  jq,
  glow,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "xdg-ninja";
  version = "0-unstable-2026-05-10";

  src = fetchFromGitHub {
    owner = "b3nj5m1n";
    repo = "xdg-ninja";
    rev = "f2ab12bbf1cf60dc3cc9459d122811c55ba88150";
    hash = "sha256-VNYZ9WKspAL2mUb1SDuGxv1MhOCBya7eEMJmy5H99xU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 xdg-ninja.sh "$out/share/xdg-ninja/xdg-ninja.sh"
    install -Dm644 programs/* -t "$out/share/xdg-ninja/programs"

    mkdir -p "$out/bin"
    ln -s "$out/share/xdg-ninja/xdg-ninja.sh" "$out/bin/xdg-ninja"

    wrapProgram "$out/bin/xdg-ninja" \
      --prefix PATH : "${
        lib.makeBinPath [
          glow
          jq
        ]
      }"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Shell script which checks your $HOME for unwanted files and directories";
    homepage = "https://github.com/b3nj5m1n/xdg-ninja";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ arcuru ];
    mainProgram = "xdg-ninja";
  };
}
