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
  version = "0.2.0.2-unstable-2025-03-09";

  src = fetchFromGitHub {
    owner = "b3nj5m1n";
    repo = "xdg-ninja";
    rev = "a964a4a4a9b2e34eb3f684f72f5c751c18b27348";
    hash = "sha256-rFGVRbjpXBDS8qae9xv9pL6dNlZNN/WYC3taUFK8O2U=";
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

  meta = with lib; {
    description = "Shell script which checks your $HOME for unwanted files and directories";
    homepage = "https://github.com/b3nj5m1n/xdg-ninja";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ arcuru ];
    mainProgram = "xdg-ninja";
  };
}
