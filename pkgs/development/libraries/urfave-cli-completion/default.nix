{ lib, stdenv, fetchFromGitHub, writeShellScript, urfave-cli-completion_1, urfave-cli-completion_2 }:

stdenv.mkDerivation rec {
  pname = "urfave-cli-completion";
  version = "2.3.0";

  srcs = [
    urfave-cli-completion_1
    urfave-cli-completion_2
  ];

  dontUnpack = true;
  installPhase = let
    linkCompletionsScript = writeShellScript "linkCompletions" ''
      VER="$1"; NAME="$2"; OUT="$3"
      DIR="$( cd "$( dirname "''${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
      mkdir -p $OUT/share/bash-completion/completions $OUT/share/zsh/site-functions
      # Our typical $NAME.bash format wouldn't work with the script
      ln -s "$DIR/$VER/bash_autocomplete" \
            "$out/share/bash-completion/completions/$NAME"
      ln -s "$DIR/$VER/zsh_autocomplete" \
            "$out/share/zsh/site-functions/_$NAME"
    '';
  in
  ''
    runHook preInstallCheck
    mkdir -p $out/share/urfave-cli-complete
    ln -s ${urfave-cli-completion_2}/share/urfave-cli-complete/v2 $out/share/urfave-cli-complete
    ln -s ${urfave-cli-completion_1}/share/urfave-cli-complete/v1 $out/share/urfave-cli-complete
    install -D ${linkCompletionsScript} $out/share/urfave-cli-complete/linkCompletions
  '';

  meta = with lib; {
    homepage = "https://github.com/urfave/cli/";
    description = "Auto-completion files for urfave/cli powered tools";
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.all;
  };
}
