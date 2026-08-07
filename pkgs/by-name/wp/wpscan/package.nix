{
  lib,
  bundlerApp,
  makeWrapper,
  curl,
}:

bundlerApp {
  pname = "wpscan";
  gemdir = ./.;
  exes = [ "wpscan" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/wpscan" \
      --prefix PATH : ${lib.makeBinPath [ curl ]}
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Black box WordPress vulnerability scanner";
    homepage = "https://wpscan.org/";
    changelog = "https://github.com/wpscanteam/wpscan/releases";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [
      nyanloutre
    ];
    platforms = lib.platforms.unix;
  };
}
