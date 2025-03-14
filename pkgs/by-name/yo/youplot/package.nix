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

  meta = with lib; {
    description = "Command line tool that draws plots on the terminal";
    homepage = "https://github.com/red-data-tools/YouPlot";
    mainProgram = "uplot";
    license = licenses.mit;
    maintainers = with maintainers; [ purcell ];
    platforms = platforms.unix;
  };
}
