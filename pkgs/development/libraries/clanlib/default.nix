{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libGL
, libpng
, pkg-config
, xorg
, file
, freetype
, fontconfig
, alsa-lib
, libXrender
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

  meta = with lib; {
    homepage = "https://github.com/sphair/ClanLib";
    description = "Cross platform toolkit library with a primary focus on game creation";
    license = licenses.mit;
    maintainers = with maintainers; [ nixinator ];
    platforms = [ "x86_64-linux" ];
  };
}
