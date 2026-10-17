{
  lib,
  stdenv,
  fetchFromGitHub,

  # build-time
  gettext,
  makeWrapper,
  pkg-config,
  python3,
  which,

  # runtime/link-time
  avahi,
  bzip2,
  dbus,
  dtv-scan-tables,
  ffmpeg,
  gnutar,
  gzip,
  libdvbcsa,
  libiconv,
  openssl,
  pcre2,
  uriparser,
  zlib,

  # optional codec-profile integrations (autodetected)
  libopus,
  libvpx,
  x264,
  x265,
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.requests ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tvheadend";
  version = "4.3-unstable-2026-02-25";

  src = fetchFromGitHub {
    owner = "tvheadend";
    repo = "tvheadend";
    rev = "7c4011de1087da5d43bf1c7537163f871fd161e4";
    hash = "sha256-/gS7xgprropq2OLp2qMv4M8gqeApuvOOArKWFqhnWNU=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    gettext
    makeWrapper
    pkg-config
    pythonEnv
    which
  ];

  buildInputs = [
    avahi
    bzip2
    dbus
    ffmpeg
    gzip
    libdvbcsa
    libiconv
    libopus
    libvpx
    openssl
    pcre2
    uriparser
    x264
    x265
    zlib
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--nowerror"

    # avoid network during build
    "--disable-dvbscan"

    # use system libraries; avoid embedded builds
    "--disable-ffmpeg_static"
    "--disable-hdhomerun_client"
    "--disable-hdhomerun_static"
    "--disable-libx264_static"
    "--disable-libx265_static"
    "--disable-libvpx_static"
    "--disable-libtheora_static"
    "--disable-libvorbis_static"
    "--disable-libfdkaac_static"
    "--disable-libmfx_static"
  ];

  preConfigure = ''
    # Ensure config backups work on NixOS (no FHS tar paths).
    substituteInPlace src/config.c \
      --replace-fail '"/usr/local/bin/tar"' '"${gnutar}/bin/tar"' \
      --replace-fail '"/usr/bin/tar"' '"${gnutar}/bin/tar"' \
      --replace-fail '"/bin/tar"' '"${gnutar}/bin/tar"'

    # Point predefined mux lists at the packaged scan tables.
    substituteInPlace src/input/mpegts/scanfile.c \
      --replace-fail /usr/share/dvb ${dtv-scan-tables}/share/dvbv5

    # The version detection script `support/version` reads this file if it
    # exists, so set it explicitly for tarball builds.
    echo ${finalAttrs.version} > rpm/version
  '';

  postInstall = ''
    # Fix scripts shipped by upstream to not rely on a host-provided python3.
    for f in $out/bin/tvhmeta $out/bin/tv_meta_tmdb.py $out/bin/tv_meta_tvdb.py; do
      substituteInPlace "$f" \
        --replace-fail '#! /usr/bin/env python3' '#!${pythonEnv}/bin/python3'
    done

    # `tar -j` needs bzip2 in PATH for config backups.
    wrapProgram $out/bin/tvheadend \
      --prefix PATH : ${lib.makeBinPath [ bzip2 ]}
  '';

  meta = {
    description = "TV streaming server and digital video recorder";
    homepage = "https://tvheadend.org";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ juaningan ];
    platforms = lib.platforms.linux;
    mainProgram = "tvheadend";
  };
})
