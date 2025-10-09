{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
}:

# To make use of this derivation, use
# `programs.zsh.interactiveShellInit = "source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";`

stdenv.mkDerivation rec {
  pname = "zsh-nix-shell";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "chisui";
    repo = "zsh-nix-shell";
    rev = "v${version}";
    sha256 = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
  };

  strictDeps = true;
  buildInputs = [ bash ];
  installPhase = ''
    install -D nix-shell.plugin.zsh --target-directory=$out/share/zsh-nix-shell
    install -D scripts/* --target-directory=$out/share/zsh-nix-shell/scripts
  '';

  meta = with lib; {
    description = "Zsh plugin that lets you use zsh in nix-shell shell";
    homepage = src.meta.homepage;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aw ];
  };
}
