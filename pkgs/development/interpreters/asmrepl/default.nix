{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "asmrepl";
  gemdir = ./.;
  exes = [ "asmrepl" ];

  passthru.updateScript = bundlerUpdateScript "asmrepl";

<<<<<<< HEAD
  meta = {
    description = "REPL for x86-64 assembly language";
    homepage = "https://github.com/tenderlove/asmrepl";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.x86_64;
=======
  meta = with lib; {
    description = "REPL for x86-64 assembly language";
    homepage = "https://github.com/tenderlove/asmrepl";
    license = licenses.asl20;
    maintainers = with maintainers; [ lom ];
    platforms = platforms.x86_64;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
