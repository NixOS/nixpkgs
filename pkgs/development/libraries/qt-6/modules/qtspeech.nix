{ qtModule
, qtbase
, qtmultimedia
, pkg-config
, flite
, alsa-lib
, speechd
}:

qtModule {
  pname = "qtspeech";
  qtInputs = [ qtbase qtmultimedia ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ flite alsa-lib speechd ];
}
