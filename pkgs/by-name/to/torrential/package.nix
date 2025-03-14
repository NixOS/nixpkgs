{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  python3,
  vala,
  wrapGAppsHook4,
  curl,
  dht,
  glib,
  gtk4,
  libb64,
  libevent,
  libgee,
  libnatpmp,
  libtransmission_3,
  libutp,
  miniupnpc,
  openssl,
  pantheon,
}:

stdenv.mkDerivation rec {
  pname = "torrential";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "davidmhewitt";
    repo = "torrential";
    rev = version;
    sha256 = "sha256-uHc/VNtbhetmGyuhynZH1TvxJscVX17eWO6dzX6Ft3A=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    curl
    dht
    glib
    gtk4
    libb64
    libevent
    libgee
    libnatpmp
    libtransmission_3
    libutp
    miniupnpc
    openssl
    pantheon.granite7
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

    substituteInPlace meson/post_install.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Download torrents in style with this speedy, minimalist torrent client for elementary OS";
    homepage = "https://github.com/davidmhewitt/torrential";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    mainProgram = "com.github.davidmhewitt.torrential";
  };
}
