{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gtest,
  tinycmmc,
  libmodplug,
  libogg,
  libvorbis,
  mpg123,
  openal,
  opusfile,
  libopus,
}:

stdenv.mkDerivation {
  pname = "wstsound";
  version = "0.3.0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "WindstilleTeam";
    repo = "wstsound";
    rev = "2c7b00dc1af52432185dc28c4ae87c09c9f4f444";
    sha256 = "sha256-fus1ydypnDDHsQwMkYyZuRikZLbZXLlc/cY8Qol5Hwo=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gtest
    tinycmmc
  ];
  propagatedBuildInputs = [
    libmodplug
    libogg
    libvorbis
    mpg123
    openal
    opusfile
    libopus
  ];

  cmakeFlags = [
    "-DWARNINGS=ON"
    "-DWERROR=ON"
    "-DBUILD_TESTS=ON"
    "-DBUILD_EXTRA=ON"
  ];

  # Test "openal_info fails"
  doCheck = false;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "COMMAND openal_info" "COMMAND openal-info"
  '';

  meta = {
    description = "Windstille Sound Library";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.free;
  };
}
