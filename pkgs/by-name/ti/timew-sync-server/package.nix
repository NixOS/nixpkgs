{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "timew-sync-server";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "timewarrior-synchronize";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3THRP+hydvq/dnxzUOFGeuu8//qL7pFN0RHJVxzgibI=";
  };

  vendorHash = "sha256-w7I8PDQQeICDPln2Naf6whOg9qqOniTH/xs1/9luIVc=";

  meta = with lib; {
    homepage = "https://github.com/timewarrior-synchronize/timew-sync-server";
    description = "Server component of timewarrior synchronization application";
    license = licenses.mit;
    maintainers = [ maintainers.joachimschmidt557 ];
    platforms = platforms.linux;
    mainProgram = "timew-sync-server";
  };
}
