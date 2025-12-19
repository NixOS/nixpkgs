{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "td";
  gemdir = ./.;
  exes = [ "td" ];

  passthru.updateScript = bundlerUpdateScript "td";

  meta = {
    description = "CLI to manage data on Treasure Data, the Hadoop-based cloud data warehousing";
    homepage = "https://github.com/treasure-data/td";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      groodt
      nicknovitski
    ];
    platforms = lib.platforms.unix;
    mainProgram = "td";
  };
}
