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
  version = "0.2.0.2-unstable-2025-08-07";

  src = fetchFromGitHub {
    owner = "b3nj5m1n";
    repo = "xdg-ninja";
    rev = "854929e5413e8d2cf84e90c5cc3ccb0188ab5d22";
    hash = "sha256-Kgu+LEU1SeB3ODyLihYG+IaQ2TMEFf3gxtjNM1FZz98=";
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
