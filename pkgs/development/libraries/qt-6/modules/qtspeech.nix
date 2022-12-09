{ qtModule
, lib
, stdenv
, qtbase
, qtmultimedia
, pkg-config
, flite
, alsa-lib
, speechd
, Cocoa
}:

qtModule {
  pname = "qtspeech";
  qtInputs = [ qtbase qtmultimedia ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ flite alsa-lib speechd ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ Cocoa ];
}
