{ stdenv, lib }:

stdenv.mkDerivation {
  pname = "zsh-clipboard";
  version = "1.0";

  dontUnpack = true;
  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    install -D -m0444 -T ${./clipboard.plugin.zsh} $out/share/zsh/plugins/clipboard/clipboard.plugin.zsh
  '';

  meta = with lib; {
    description = "Ohmyzsh plugin that integrates kill-ring with system clipboard";
    longDescription = ''
      Ohmyzsh plugin that integrates kill-ring with system clipboard.

      Key bindings for C-y, C-k, C-u, M-d, M-backspace and M-w are rebound.
      Behaviour of these keys should not be changed.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ bb2020 ];
    platforms = platforms.unix;
  };
}
