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

<<<<<<< HEAD
  meta = {
    description = "Command-line power tool for Twitter";
    homepage = "http://sferik.github.io/t/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Command-line power tool for Twitter";
    homepage = "http://sferik.github.io/t/";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      offline
      manveru
      nicknovitski
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "t";
  };
}
