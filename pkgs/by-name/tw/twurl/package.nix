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

<<<<<<< HEAD
  meta = {
    description = "OAuth-enabled curl for the Twitter API";
    homepage = "https://github.com/twitter/twurl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ brecht ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "OAuth-enabled curl for the Twitter API";
    homepage = "https://github.com/twitter/twurl";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ brecht ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "twurl";
  };
}
