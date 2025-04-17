{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  audacious-bare,
  mpg123,
  ffmpeg,
  libvorbis,
  libao,
  speex,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "vgmstream";
  version = "1980";

  src = fetchFromGitHub {
    owner = "vgmstream";
    repo = "vgmstream";
    tag = "r${version}";
    hash = "sha256-TmaWC04XbtFfBYhmTO4ouh3NoByio1BCpDJGJy3r0NY=";
  };

  passthru.updateScript = nix-update-script {
    attrPath = "vgmstream";
    extraArgs = [
      "--version-regex"
      "r(.*)"
    ];
  };

  outputs = [
    "out"
    "audacious"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gtk3
  ];

  buildInputs = [
    mpg123
    ffmpeg
    libvorbis
    libao
    speex
    audacious-bare
  ];

  preConfigure = ''
    substituteInPlace cmake/dependencies/audacious.cmake \
      --replace "pkg_get_variable(AUDACIOUS_PLUGIN_DIR audacious plugin_dir)" "set(AUDACIOUS_PLUGIN_DIR \"$audacious/lib/audacious\")"
  '';

  cmakeFlags = [
    # It always tries to download it, no option to use the system one
    "-DUSE_CELT=OFF"
  ];

  meta = with lib; {
    description = "Library for playback of various streamed audio formats used in video games";
    homepage = "https://vgmstream.org";
    maintainers = with maintainers; [ zane ];
    license = with licenses; isc;
    platforms = with platforms; unix;
  };
}
