{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "tmuxifier";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "jimeh";
    repo = "tmuxifier";
    rev = "v${version}";
    hash = "sha256-7TvJnvtZEo5h45PcSy3tJN09UblswV0mQbTaKjgLyqw=";
  };

  nativeBuildInputs = [ installShellFiles ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    sed -i "s@set -e@TMUXIFIER=$out\nTMUXIFIER_LAYOUT_PATH=\"\''${TMUXIFIER_LAYOUT_PATH:-\$HOME/.tmux-layouts}\"\nset -e@" \
        bin/tmuxifier
    sed -i "s@\$TMUXIFIER/lib/@\$TMUXIFIER/lib/tmuxifier/@g" \
        bin/tmuxifier libexec/* lib/*
    sed -i "s@\$TMUXIFIER/templates/@\$TMUXIFIER/share/tmuxifier/templates/@g; s@\$TMUXIFIER/init.@\$TMUXIFIER/share/tmuxifier/init/init.@g" \
        libexec/*
    sed -i "s@\$TMUXIFIER/completion/tmuxifier.bash@\$TMUXIFIER/share/bash-completion/completions/tmuxifier.bash@g; s@\$TMUXIFIER/completion/tmuxifier.zsh@\$TMUXIFIER/share/zsh/site-functions/_tmuxifier@g" \
        init.sh
    sed -i "s@\$TMUXIFIER/completion/tmuxifier.tcsh@\$TMUXIFIER/share/tmuxifier/completion/tmuxifier.tcsh@g" \
        init.tcsh
    sed -i "s@\$TMUXIFIER/completion/tmuxifier.fish@\$TMUXIFIER/share/fish/vendor_completions.d/tmuxifier.fish@g" \
        init.fish

    install -t $out/bin -Dm555 bin/tmuxifier
    install -t $out/share/tmuxifier/init -Dm444 init.fish init.sh init.tcsh
    install -t $out/share/tmuxifier/templates -Dm444 templates/*
    install -t $out/lib/tmuxifier -Dm444 lib/*
    cp -r libexec $out
    installShellCompletion --cmd tmuxifier \
        --bash completion/tmuxifier.bash \
        --fish completion/tmuxifier.fish \
        --zsh completion/tmuxifier.zsh
    install -t $out/share/tmuxifier/completion -Dm444 completion/tmuxifier.tcsh

    runHook postInstall
  '';

  meta = with lib; {
    description = "Powerful session, window & pane management for Tmux";
    homepage = "https://github.com/jimeh/tmuxifier";
    license = licenses.mit;
    mainProgram = "tmuxifier";
    maintainers = with maintainers; [ wigust ];
    platforms = platforms.unix;
  };
}
