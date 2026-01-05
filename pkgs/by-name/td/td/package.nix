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

  meta = with lib; {
    description = "CLI to manage data on Treasure Data, the Hadoop-based cloud data warehousing";
    homepage = "https://github.com/treasure-data/td";
    license = licenses.asl20;
    maintainers = with maintainers; [
      groodt
      nicknovitski
    ];
    platforms = platforms.unix;
    mainProgram = "td";
  };
}
