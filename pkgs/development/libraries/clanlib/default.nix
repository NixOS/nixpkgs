{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  libGL,
  libpng,
  pkg-config,
  xorg,
  freetype,
  fontconfig,
  alsa-lib,
  libXrender,
}:

stdenv.mkDerivation rec {
  pname = "clanlib";
  version = "4.1.0";

  src = fetchFromGitHub {
    repo = "ClanLib";
    owner = "sphair";
    rev = "v${version}";
    sha256 = "sha256-SVsLWcTP+PCIGDWLkadMpJPj4coLK9dJrW4sc2+HotE=";
  };

  patches = [
    (fetchpatch {
      name = "clanlib-add-support-for-riscv.patch";
      url = "https://github.com/sphair/ClanLib/commit/f5f694205054b66dc800135c9b01673f69a7a671.patch";
      hash = "sha256-/1XLFaTZDQAlT2mG9P6SJzXtTg7IWYGQ18Sx0e9zh0s=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libGL
    libpng
    xorg.xorgproto
    freetype
    fontconfig
    alsa-lib
    libXrender
  ];

  meta = {
    homepage = "https://github.com/sphair/ClanLib";
    description = "Cross platform toolkit library with a primary focus on game creation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nixinator ];
    platforms = with lib.platforms; lib.intersectLists linux (x86 ++ arm ++ aarch64 ++ riscv);
  };
}
