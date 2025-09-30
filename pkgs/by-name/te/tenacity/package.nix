{
  stdenv,
  lib,
  fetchFromGitea,
  cmake,
  ninja,
  wxGTK32,
  gtk3,
  pkg-config,
  python3,
  gettext,
  glib,
  file,
  lame,
  libvorbis,
  libmad,
  libjack2,
  lv2,
  lilv,
  makeWrapper,
  serd,
  sord,
  sqlite,
  sratom,
  suil,
  alsa-lib,
  libsndfile,
  soxr,
  flac,
  twolame,
  expat,
  libid3tag,
  libopus,
  ffmpeg,
  soundtouch,
  pcre,
  portaudio,
  linuxHeaders,
  at-spi2-core,
  dbus,
  libepoxy,
  libXdmcp,
  libXtst,
  libpthreadstubs,
  libselinux,
  libsepol,
  libxkbcommon,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tenacity";
  version = "1.3.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "tenacityteam";
    repo = "tenacity";
    fetchSubmodules = true;
    rev = "v${finalAttrs.version}";
    hash = "sha256-2gndOwgEJK2zDSbjcZigbhEpGv301/ygrf+EQhKp8PI=";
  };

  postPatch = ''
    # GIT_DESCRIBE is used for the version string and can't be passed in
    # as an option, so we substitute it instead.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set( GIT_DESCRIBE "unknown" )' 'set( GIT_DESCRIBE "${finalAttrs.version}" )'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace libraries/lib-files/FileNames.cpp \
      --replace-fail /usr/include/linux/magic.h ${linuxHeaders}/include/linux/magic.h
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Tenacity has special handling for ffmpeg library search on darwin,
    # looking only in a few specific directories.
    # Make sure it searches for our version of ffmpeg in the nix store.
    substituteInPlace libraries/lib-ffmpeg-support/FFmpegFunctions.cpp \
      --replace-fail /usr/local/lib/tenacity ${lib.getLib ffmpeg}/lib
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/{bin,Applications}
    mv $out/{,Applications/}Tenacity.app

    # Symlinking the binary is insufficient as it would be unable to
    # find the bundle resources
    cat << EOF > "$out/bin/tenacity"
    #!${stdenv.shell}
    open -na "$out/Applications/Tenacity.app" --args "\$@"
    EOF
    chmod +x "$out/bin/tenacity"

    # Only contains a static library that is already linked into the tenacity binary
    rm -r $out/lib
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram "$out/bin/tenacity" \
      --suffix AUDACITY_PATH : "$out/share/tenacity" \
      --suffix AUDACITY_MODULES_PATH : "$out/lib/tenacity/modules" \
      --prefix LD_LIBRARY_PATH : "$out/lib/tenacity" \
      --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  # Tenacity only looks for ffmpeg at runtime, so we need to link it in manually.
  # On darwin, these are ignored by the ffmpeg search even when linked.
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux (toString [
    "-lavcodec"
    "-lavdevice"
    "-lavfilter"
    "-lavformat"
    "-lavutil"
    "-lpostproc"
    "-lswresample"
    "-lswscale"
  ]);

  nativeBuildInputs = [
    cmake
    ninja
    gettext
    pkg-config
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    makeWrapper
    linuxHeaders
  ];

  buildInputs = [
    expat
    ffmpeg
    file
    flac
    glib
    lame
    libid3tag
    libjack2
    libmad
    libopus
    libsndfile
    libvorbis
    lilv
    lv2
    pcre
    portaudio
    serd
    sord
    soundtouch
    soxr
    sqlite
    sratom
    suil
    twolame
    wxGTK32
    gtk3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    at-spi2-core
    dbus
    libepoxy
    libXdmcp
    libXtst
    libpthreadstubs
    libxkbcommon
    libselinux
    libsepol
    util-linux
  ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    # Disabled by default on Linux but enabled on Darwin, so we disable it explicitly for all platforms,
    # as we provide dependencies from nixpkgs regardless of the target platform.
    "-DVCPKG=OFF"
  ];

  meta = {
    description = "Sound editor with graphical UI";
    mainProgram = "tenacity";
    homepage = "https://tenacityaudio.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      irenes
      niklaskorz
    ];
    platforms = lib.platforms.unix;
  };
})
