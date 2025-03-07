{
  lib,
  autoconf-archive,
  autoreconfHook,
  boost,
  fetchFromGitHub,
  libtorrent-rasterbar,
  libvlc,
  openssl,
  pkg-config,
  stdenv,
}:

# VLC does not know where the vlc-bittorrent package is installed.
# make sure to have something like:
#   environment.variables.VLC_PLUGIN_PATH = "${pkgs.vlc-bittorrent}";

stdenv.mkDerivation (finalAttrs: {
  pname = "vlc-bittorrent";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "johang";
    repo = "vlc-bittorrent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7FHeQYHbMKZJ3yeHqxTTAUwghTje+gEX8gSEJzfG5sQ=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    boost
    libtorrent-rasterbar
    libvlc
    openssl
  ];

  strictDeps = true;

  # It's a library, should not have a desktop file
  postFixup = ''
    rm -r $out/share/
  '';

  meta = with lib; {
    description = "Bittorrent plugin for VLC";
    homepage = "https://github.com/johang/vlc-bittorrent";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.kintrix ];
  };
})
