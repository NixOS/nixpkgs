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

  meta = {
    description = "Detect stegano-hidden data in PNG & BMP";
    homepage = "http://zed.0xff.me/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      applePrincess
      h7x4
    ];
    mainProgram = "zsteg";
  };
}
