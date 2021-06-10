{ stdenv
, lib
, config
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsa-lib
, pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux
, libpulseaudio
, jackSupport ? true
, jack
, coreaudioSupport ? stdenv.hostPlatform.isDarwin
, CoreAudio
}:

stdenv.mkDerivation rec {
  version = "5.1.0";
  pname = "rtaudio";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtaudio";
    rev = version;
    sha256 = "1pglnjz907ajlhnlnig3p0sx7hdkpggr8ss7b3wzf1lykzgv9l52";
  };

  patches = [
    # Fixes missing headers & install location
    # Drop with version > 5.1.0
    (fetchpatch {
      name = "RtAudio-Adjust-CMake-public-header-installs-to-match-autotools.patch";
      url = "https://github.com/thestk/rtaudio/commit/4273cf7572b8f51b5996cf6b42e3699cc6b165da.patch";
      sha256 = "1p0idll0xsfk3jwjg83jkxkaf20gk0wqa7l982ni389rn6i4n26p";
    })
  ];

  postPatch = ''
    substituteInPlace rtaudio.pc.in \
      --replace 'Requires:' 'Requires.private:'
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional jackSupport jack
    ++ lib.optional coreaudioSupport CoreAudio;

  cmakeFlags = [
    "-DRTAUDIO_API_ALSA=${if alsaSupport then "ON" else "OFF"}"
    "-DRTAUDIO_API_PULSE=${if pulseaudioSupport then "ON" else "OFF"}"
    "-DRTAUDIO_API_JACK=${if jackSupport then "ON" else "OFF"}"
    "-DRTAUDIO_API_CORE=${if coreaudioSupport then "ON" else "OFF"}"
  ];

  meta = with lib; {
    description = "A set of C++ classes that provide a cross platform API for realtime audio input/output";
    homepage = "https://www.music.mcgill.ca/~gary/rtaudio/";
    license = licenses.mit;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.unix;
  };
}
