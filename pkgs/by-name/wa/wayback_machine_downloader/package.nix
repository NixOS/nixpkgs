{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:
bundlerApp {
  pname = "wayback_machine_downloader_straw";
  exes = [ "wayback_machine_downloader" ];
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "wayback_machine_downloader_straw";

  meta = {
    description = "Download websites from the Internet Archive Wayback Machine";
    homepage = "https://github.com/StrawberryMaster/wayback-machine-downloader";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "wayback_machine_downloader";
  };
}
