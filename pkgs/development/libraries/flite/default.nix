<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, fetchpatch
, libpulseaudio
, audioBackend ? "pulseaudio"
}:

assert lib.assertOneOf "audioBackend" audioBackend [ "alsa" "pulseaudio" ];
=======
{ lib, stdenv, fetchFromGitHub, alsa-lib, fetchpatch }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "flite";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "festvox";
    repo = "flite";
    rev = "v${version}";
    sha256 = "1n0p81jzndzc1rzgm66kw9ls189ricy5v1ps11y0p2fk1p56kbjf";
  };

<<<<<<< HEAD
  buildInputs = lib.optional (stdenv.isLinux && audioBackend == "alsa") alsa-lib
    ++ lib.optional (stdenv.isLinux && audioBackend == "pulseaudio") libpulseaudio;
=======
  buildInputs = lib.optionals stdenv.isLinux [ alsa-lib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # https://github.com/festvox/flite/pull/60.
  # Replaces `ar` with `$(AR)` in config/common_make_rules.
  # Improves cross-compilation compatibility.
  patches = [
    (fetchpatch {
      url = "https://github.com/festvox/flite/commit/54c65164840777326bbb83517568e38a128122ef.patch";
      sha256 = "sha256-hvKzdX7adiqd9D+9DbnfNdqEULg1Hhqe1xElYxNM1B8=";
    })
  ];

  configureFlags = [
    "--enable-shared"
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isLinux [ "--with-audio=${audioBackend}" ];
=======
  ] ++ lib.optionals stdenv.isLinux [ "--with-audio=alsa" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # main/Makefile creates and removes 'flite_voice_list.c' from multiple targets:
  # make[1]: *** No rule to make target 'flite_voice_list.c', needed by 'all'.  Stop
  enableParallelBuilding = false;

  meta = with lib; {
    description = "A small, fast run-time speech synthesis engine";
    homepage = "http://www.festvox.org/flite/";
    license = licenses.bsdOriginal;
<<<<<<< HEAD
    maintainers = with maintainers; [ getchoo ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.all;
  };
}
