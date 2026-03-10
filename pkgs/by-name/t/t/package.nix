{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "t";
  gemdir = ./.;
  exes = [ "t" ];

  passthru.updateScript = bundlerUpdateScript "t";

  meta = {
    description = "Command-line power tool for Twitter";
    homepage = "http://sferik.github.io/t/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nicknovitski
    ];
    platforms = lib.platforms.unix;
    mainProgram = "t";
  };
}
