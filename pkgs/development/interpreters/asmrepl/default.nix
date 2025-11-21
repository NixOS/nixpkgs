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

  meta = {
    description = "REPL for x86-64 assembly language";
    homepage = "https://github.com/tenderlove/asmrepl";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.x86_64;
  };
}
