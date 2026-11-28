{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsh-sage";
  version = "1.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "UtsavMandal2022";
    repo = "zsh-sage";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-mh3p7dUaR5iiy/xAf1zUFs1V12dBvLfV3xp4aB2TkYU=";
  };

  strictDeps = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/zsh-sage
    cp -r * $out/share/zsh-sage/

    runHook postInstall
  '';

  meta = {
    description = "Intelligent zsh autosuggestions with multi-signal ranking and confidence-colored ghost text";
    homepage = "https://github.com/UtsavMandal2022/zsh-sage";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mio ];
  };
})
