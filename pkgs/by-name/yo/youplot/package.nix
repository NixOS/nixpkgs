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

  meta = {
    description = "Command line tool that draws plots on the terminal";
    homepage = "https://github.com/red-data-tools/YouPlot";
    mainProgram = "uplot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ purcell ];
    platforms = lib.platforms.unix;
  };
}
