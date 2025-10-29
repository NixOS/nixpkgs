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

  meta = with lib; {
    description = "Black box WordPress vulnerability scanner";
    homepage = "https://wpscan.org/";
    changelog = "https://github.com/wpscanteam/wpscan/releases";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [
      nyanloutre
      manveru
    ];
    platforms = platforms.unix;
  };
}
