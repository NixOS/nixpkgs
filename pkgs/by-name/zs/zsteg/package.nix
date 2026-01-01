{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp rec {
  pname = "zsteg";

  gemdir = ./.;

  exes = [ "zsteg" ];

  passthru.updateScript = bundlerUpdateScript pname;

<<<<<<< HEAD
  meta = {
    description = "Detect stegano-hidden data in PNG & BMP";
    homepage = "http://zed.0xff.me/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Detect stegano-hidden data in PNG & BMP";
    homepage = "http://zed.0xff.me/";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      applePrincess
      h7x4
    ];
    mainProgram = "zsteg";
  };
}
