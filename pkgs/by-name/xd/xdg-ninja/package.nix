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
  version = "0.2.0.2-unstable-2026-04-18";

  src = fetchFromGitHub {
    owner = "b3nj5m1n";
    repo = "xdg-ninja";
    rev = "3cb5c53293838d624d29ae249fb3507703af4631";
    hash = "sha256-iviya6odP0qEguvxcxni5wLGAFTWt8pnWmIEo1bNCbI=";
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
