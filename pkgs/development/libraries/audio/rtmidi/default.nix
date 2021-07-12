{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsa-lib
, jackSupport ? true
, jack
, coremidiSupport ? stdenv.hostPlatform.isDarwin
, CoreMIDI
, CoreAudio
, CoreServices
}:

stdenv.mkDerivation rec {
  version = "4.0.0";
  pname = "rtmidi";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtmidi";
    rev = version;
    sha256 = "1g31p6a96djlbk9jh5r4pjly3x76lhccva9hrw6xzdma8dsjzgyq";
  };

  patches = [
    # PR #230, fix CMake problems
    (fetchpatch {
      name = "RtMidi-Fix-JACK_HAS_PORT_RENAME-define.patch";
      url = "https://github.com/thestk/rtmidi/pull/230/commits/768a30a61b60240b66cc2d43bc27a544ff9f1622.patch";
      sha256 = "1sym4f7nb2qyyxfhi1l0xsm2hfh6gddn81y36qvfq4mcs33vvid0";
    })
    (fetchpatch {
      name = "RtMidi-Add-prefix-define-for-pkgconfig.patch";
      url = "https://github.com/thestk/rtmidi/pull/230/commits/7a32e23e3f6cb43c0d2d58443ce205d438e76f44.patch";
      sha256 = "06im8mb05wah6bnkadw2gpkhmilxb8p84pxqr50b205cchpq304w";
    })
    (fetchpatch {
      name = "RtMidi-Adjust-public-header-installs-to-match-autotools.patch";
      url = "https://github.com/thestk/rtmidi/pull/230/commits/892fe5492f0e787484fa4a37027b08c265ce001f.patch";
      sha256 = "0ca9m42xa3gmycimzvzvl67wa266xq9pfp1b4v555rh2fp52kbcj";
    })
  ];

  postPatch = ''
    substituteInPlace rtmidi.pc.in \
      --replace 'Requires:' 'Requires.private:'
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = lib.optional alsaSupport alsa-lib
    ++ lib.optional jackSupport jack
    ++ lib.optionals coremidiSupport [ CoreMIDI CoreAudio CoreServices ];

  cmakeFlags = [
    "-DRTMIDI_API_ALSA=${if alsaSupport then "ON" else "OFF"}"
    "-DRTMIDI_API_JACK=${if jackSupport then "ON" else "OFF"}"
    "-DRTMIDI_API_CORE=${if coremidiSupport then "ON" else "OFF"}"
  ];

  meta = with lib; {
    description = "A set of C++ classes that provide a cross platform API for realtime MIDI input/output";
    homepage = "https://www.music.mcgill.ca/~gary/rtmidi/";
    license = licenses.mit;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.unix;
  };
}
