{
  lib,
  fetchFromGitHub,
  xmrig,
}:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
  version = "6.26.0-mo2";

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
    hash = "sha256-3WYHkxPcGcA+Y9VhEGYfLs1iUKfLhkgzsRgyS8gWXPA=";
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
