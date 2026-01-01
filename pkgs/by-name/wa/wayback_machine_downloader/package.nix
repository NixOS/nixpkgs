{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:
bundlerApp {
  pname = "wayback_machine_downloader";
  exes = [ "wayback_machine_downloader" ];
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "wayback_machine_downloader";

<<<<<<< HEAD
  meta = {
    description = "Download websites from the Internet Archive Wayback Machine";
    homepage = "https://github.com/hartator/wayback-machine-downloader";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.manveru ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Download websites from the Internet Archive Wayback Machine";
    homepage = "https://github.com/hartator/wayback-machine-downloader";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "wayback_machine_downloader";
  };
}
