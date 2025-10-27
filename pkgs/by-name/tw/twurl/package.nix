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

  meta = with lib; {
    description = "OAuth-enabled curl for the Twitter API";
    homepage = "https://github.com/twitter/twurl";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ brecht ];
    platforms = platforms.unix;
    mainProgram = "twurl";
  };
}
