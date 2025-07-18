{
  stdenvNoCC,
  fetchFromGitLab,
  lib,
  full ? true,
  # see https://gitlab.com/jschx/ufetch for a list
  osName ? "nixos",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ufetch";
  version = "0.4";

  src = fetchFromGitLab {
    owner = "jschx";
    repo = "ufetch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-icrf7OjDageBRSBD40wX2ZzCvB6T5n0jgd5aRROGqCA=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/licenses/ufetch
    ${
      if !full then
        "install -Dm755 ufetch-${osName} $out/bin/ufetch"
      else
        ''
          install -Dm755 ufetch-* $out/bin
          ln -s $out/bin/ufetch-${osName} $out/bin/ufetch
        ''
    }
    install -Dm644 LICENSE $out/share/licenses/ufetch/LICENSE
    runHook postInstall
  '';

  meta = {
    description = "Tiny system info for Unix-like operating systems";
    homepage = "https://gitlab.com/jschx/ufetch";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "ufetch";
    maintainers = with lib.maintainers; [ mrtnvgr ];
  };
})
