{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchpatch,
  avahi,
  bzip2,
  dbus,
  dtv-scan-tables,
  ffmpeg,
  gettext,
  gnutar,
  jq,
  libdvbcsa,
  libiconv,
  libopus,
  libvpx,
  makeWrapper,
  nodejs,
  npmHooks,
  openssl,
  pcre2,
  pkg-config,
  python3,
  uriparser,
  versionCheckHook,
  which,
  x264,
  x265,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tvheadend";
  version = "4.3-unstable-2026-11-28";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tvheadend";
    repo = "tvheadend";
    rev = "c9e4baba52f1913e8855a3cd9ef719c9881ababb";
    hash = "sha256-4MPE1HVy12WK72EYreC0rsMIWcs2fLgKb0FkVd1A/w4=";
  };

  patches = [
    # FFmpeg 9 removed the old buffersink format options.
    # https://github.com/tvheadend/tvheadend/pull/2225
    (fetchpatch {
      url = "https://github.com/tvheadend/tvheadend/commit/bc994d8e99d69335e5e1cf2b3cb2bd8bae4ee1d9.patch";
      hash = "sha256-pJ50bI7JH1vh8BW67/SbQFO5pU+C3fhLyy3VyZq9tjM=";
    })
    (fetchpatch {
      url = "https://github.com/tvheadend/tvheadend/commit/57b87c754170663b7c80bb044fcc617a3e9f89ec.patch";
      hash = "sha256-/72TgyFr38ov5r7DJyGvl+nQbBwArDJAGcYRMxs79WY=";
    })
  ];

  npmRoot = "src/webui/static-vue";
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-/iWfH94FB9Ba5gSVB62l8XXq4U5nnihwBDZNGhGO5wc=";
  };

  outputs = [
    "out"
    "man"
  ];
  strictDeps = true;

  nativeBuildInputs = [
    gettext
    makeWrapper
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    python3
    which
  ];

  buildInputs = [
    avahi
    dbus
    ffmpeg
    libdvbcsa
    libiconv
    libopus
    libvpx
    openssl
    pcre2
    (python3.withPackages (ps: [ ps.requests ]))
    uriparser
    x264
    x265
    zlib
  ];

  postPatch = ''
    substituteInPlace src/config.c \
      --replace-fail '"/usr/local/bin/tar"' '"${gnutar}/bin/tar"' \
      --replace-fail '"/usr/bin/tar"' '"${gnutar}/bin/tar"' \
      --replace-fail '"/bin/tar"' '"${gnutar}/bin/tar"'
    substituteInPlace src/input/mpegts/scanfile.c \
      --replace-fail /usr/share/dvb ${dtv-scan-tables}/share/dvbv5

    # support/version reads this when there is no Git checkout.
    echo ${finalAttrs.version} > rpm/version
  '';

  configureFlags = [
    "--nowerror"
    "--enable-libav"
    "--disable-ffmpeg_static"
    "--disable-hdhomerun_static"
    "--disable-dvbscan"
    "--enable-vue_build"
    "--disable-pcloud_cache"
  ];

  preBuild = ''
    # npmConfigHook already ran npm ci from the pinned cache.
    touch "$npmRoot/node_modules/.installed"
  '';

  enableParallelBuilding = true;

  postInstall = ''
    # The DVR calls tvhmeta by name and tar uses bzip2 for config backups.
    wrapProgram "$out/bin/tvheadend" \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ bzip2 ]}"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    jq
    versionCheckHook
  ];
  postInstallCheck = ''
    "$out/bin/tvhmeta" --list-grabber-capabilities | jq -e 'has("tv_meta_tmdb") and has("tv_meta_tvdb")'
  '';

  meta = {
    description = "TV streaming server and digital video recorder";
    homepage = "https://tvheadend.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ juaningan ];
    platforms = lib.platforms.linux;
    mainProgram = "tvheadend";
  };
})
