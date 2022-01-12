{ buildOctavePackage
, lib
, fetchurl
, jack2
, alsa-lib
, rtmidi
, pkg-config
}:

buildOctavePackage rec {
  pname = "audio";
  version = "2.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1431pf7mhxsrnzrx8r3hsy537kha7jhaligmp2rghwyxhq25hs0r";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    jack2
    alsa-lib
    rtmidi
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/audio/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Audio and MIDI Toolbox for GNU Octave";
    platforms = platforms.linux; # Because of run-time dependency on jack2 and alsa-lib
  };
}
