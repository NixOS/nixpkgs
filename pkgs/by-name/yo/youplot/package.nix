{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "youplot";
  gemdir = ./.;

  exes = [ "uplot" ];

  passthru.updateScript = bundlerUpdateScript "youplot";

<<<<<<< HEAD
  meta = {
    description = "Command line tool that draws plots on the terminal";
    homepage = "https://github.com/red-data-tools/YouPlot";
    mainProgram = "uplot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ purcell ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Command line tool that draws plots on the terminal";
    homepage = "https://github.com/red-data-tools/YouPlot";
    mainProgram = "uplot";
    license = licenses.mit;
    maintainers = with maintainers; [ purcell ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
