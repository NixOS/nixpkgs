{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "timew-sync-server";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "timewarrior-synchronize";
    repo = "timew-sync-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3THRP+hydvq/dnxzUOFGeuu8//qL7pFN0RHJVxzgibI=";
  };

  vendorHash = "sha256-w7I8PDQQeICDPln2Naf6whOg9qqOniTH/xs1/9luIVc=";

  meta = {
    homepage = "https://github.com/timewarrior-synchronize/timew-sync-server";
    description = "Server component of timewarrior synchronization application";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.joachimschmidt557 ];
    platforms = lib.platforms.linux;
    mainProgram = "timew-sync-server";
  };
})
