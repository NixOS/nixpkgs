{ qtModule
, lib
, stdenv
, qtbase
, qtmultimedia
, pkg-config
, flite
, alsa-lib
, speechd-minimal
, Cocoa
}:

qtModule {
  pname = "qtspeech";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ flite alsa-lib speechd-minimal ];
  propagatedBuildInputs = [ qtbase qtmultimedia ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Cocoa ];
}
