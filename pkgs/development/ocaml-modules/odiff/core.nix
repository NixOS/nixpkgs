{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "odiff-core";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "odiff";
    tag = "v${version}";
    hash = "sha256-WCl0Ze2KglFvycr0sx8H/cHKb/Fx1cfDY/VKii7kK1I=";
  };

  meta = {
    homepage = "https://github.com/dmtrKovalenko/odiff";
    description = "The fastest pixel-by-pixel image visual difference tool in the world";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kalekseev ];
  };
}
