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

<<<<<<< HEAD
  meta = {
    description = "Simple tool used to automatically create windows and panes in tmux with YAML files";
    homepage = "https://github.com/remiprev/teamocil";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Simple tool used to automatically create windows and panes in tmux with YAML files";
    homepage = "https://github.com/remiprev/teamocil";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      zachcoyle
      nicknovitski
    ];
    mainProgram = "teamocil";
  };
}
