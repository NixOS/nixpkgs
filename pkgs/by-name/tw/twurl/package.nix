{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "twurl";
  gemdir = ./.;
  exes = [ "twurl" ];

  passthru.updateScript = bundlerUpdateScript "twurl";

  meta = {
    description = "OAuth-enabled curl for the Twitter API";
    homepage = "https://github.com/twitter/twurl";
    license = "MIT";
    maintainers = with lib.maintainers; [ brecht ];
    platforms = lib.platforms.unix;
    mainProgram = "twurl";
  };
}
