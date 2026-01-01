{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "vpsfree-client";
  gemdir = ./.;
  exes = [ "vpsfreectl" ];

  passthru.updateScript = bundlerUpdateScript "vpsfree-client";

<<<<<<< HEAD
  meta = {
    description = "Ruby API and CLI for the vpsFree.cz API";
    homepage = "https://github.com/vpsfreecz/vpsfree-client";
    maintainers = with lib.maintainers; [
      aither64
      zimbatm
    ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Ruby API and CLI for the vpsFree.cz API";
    homepage = "https://github.com/vpsfreecz/vpsfree-client";
    maintainers = with maintainers; [
      aither64
      zimbatm
    ];
    license = licenses.gpl3;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "vpsfreectl";
  };
}
