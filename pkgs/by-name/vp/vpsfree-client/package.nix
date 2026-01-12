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

  meta = {
    description = "Ruby API and CLI for the vpsFree.cz API";
    homepage = "https://github.com/vpsfreecz/vpsfree-client";
    maintainers = with lib.maintainers; [
      aither64
      zimbatm
    ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "vpsfreectl";
  };
}
