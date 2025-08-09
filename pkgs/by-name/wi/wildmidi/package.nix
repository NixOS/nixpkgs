{
  lib,
  stdenv,
  fetchFromGitHub,
  writeTextFile,
  cmake,
  alsa-lib,
  freepats,
}:

let
  defaultCfgPath = "${placeholder "out"}/etc/wildmidi/wildmidi.cfg";
in
stdenv.mkDerivation rec {
  pname = "wildmidi";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "Mindwerks";
    repo = "wildmidi";
    rev = "${pname}-${version}";
    sha256 = "sha256-syjs8y75M2ul7whiZxnWMSskRJd0ixFqnep7qsTbiDE=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.buildPlatform.isLinux [
    alsa-lib
    stdenv.cc.libc # couldn't find libm
  ];

  preConfigure = ''
    # https://github.com/Mindwerks/wildmidi/issues/236
    substituteInPlace src/wildmidi.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  cmakeFlags = [
    "-DWILDMIDI_CFG=${defaultCfgPath}"
  ];

  postInstall =
    let
      defaultCfg = writeTextFile {
        name = "wildmidi.cfg";
        text = ''
          dir ${freepats}
          source ${freepats}/freepats.cfg
        '';
      };
    in
    ''
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
}
