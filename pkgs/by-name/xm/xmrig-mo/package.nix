{
  lib,
  fetchFromGitHub,
  xmrig,
}:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
  version = "6.26.0-mo1";

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
    hash = "sha256-7Jo7q1GAq8GEw7oM32I6rHFhMsZsp3Z75s7p4ox3wS0=";
  };

  meta = {
    description = "Fork of the XMRig CPU miner with support for algorithm switching";
    homepage = "https://github.com/MoneroOcean/xmrig";
    license = lib.licenses.gpl3Plus;
    mainProgram = "xmrig";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      j0hax
      redhawk
    ];
  };
})
