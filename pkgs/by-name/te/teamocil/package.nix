{
  lib,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
}:

bundlerEnv {
  inherit ruby;
  pname = "teamocil";
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "teamocil";

  meta = {
    description = "Simple tool used to automatically create windows and panes in tmux with YAML files";
    homepage = "https://github.com/remiprev/teamocil";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      zachcoyle
      nicknovitski
    ];
    mainProgram = "teamocil";
  };
}
