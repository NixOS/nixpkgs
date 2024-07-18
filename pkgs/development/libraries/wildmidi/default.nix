{ lib, stdenv, fetchFromGitHub, writeTextFile, cmake, alsa-lib, darwin, freepats }:

let
  defaultCfgPath = "${placeholder "out"}/etc/wildmidi/wildmidi.cfg";

  inherit (darwin.apple_sdk.frameworks) OpenAL CoreAudio AudioUnit AudioToolbox CoreServices;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wildmidi";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "Mindwerks";
    repo = "wildmidi";
    rev = "wildmidi-${finalAttrs.version}";
    hash = "sha256-syjs8y75M2ul7whiZxnWMSskRJd0ixFqnep7qsTbiDE=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.buildPlatform.isLinux [
    alsa-lib
    stdenv.cc.libc # couldn't find libm
  ] ++ lib.optionals stdenv.buildPlatform.isDarwin [
    OpenAL
    CoreAudio
    AudioUnit
    AudioToolbox
    CoreServices
  ];

  cmakeFlags = [
    "-DWILDMIDI_CFG=${defaultCfgPath}"
  ];

  postInstall = let
    defaultCfg = writeTextFile {
      name = "wildmidi.cfg";
      text = ''
        dir ${freepats}
        source ${freepats}/freepats.cfg
      '';
    };
  in ''
    mkdir -p "$(dirname ${defaultCfgPath})"
    ln -s ${defaultCfg} ${defaultCfgPath}
  '';

  meta = with lib; {
    description = "Software MIDI player and library";
    mainProgram = "wildmidi";
    longDescription = ''
      WildMIDI is a simple software midi player which has a core softsynth
      library that can be use with other applications.
    '';
    homepage = "https://wildmidi.sourceforge.net/";
    # The library is LGPLv3, the wildmidi executable is GPLv3
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
})
