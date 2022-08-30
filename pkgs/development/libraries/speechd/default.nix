{ stdenv
, lib
, substituteAll
, pkg-config
, fetchurl
, python3Packages
, gettext
, itstool
, libtool
, texinfo
, util-linux
, autoreconfHook
, glib
, dotconf
, libsndfile
, withLibao ? true, libao
, withPulse ? false, libpulseaudio
, withAlsa ? false, alsa-lib
, withOss ? false
, withFlite ? true, flite
, withEspeak ? true, espeak, sonic, pcaudiolib
, mbrola
, withPico ? true, svox
}:

let
  inherit (python3Packages) python pyxdg wrapPython;
in stdenv.mkDerivation rec {
  pname = "speech-dispatcher";
  version = "0.11.2";

  src = fetchurl {
    url = "https://github.com/brailcom/speechd/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-i0ZJkl5oy+GntMCge7BBznc4s1yQamAr+CmG2xqg82Q=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      utillinux = util-linux;
    })
  ] ++ lib.optionals espeak.mbrolaSupport [
    # Replace FHS paths.
    (substituteAll {
      src = ./fix-mbrola-paths.patch;
      inherit espeak mbrola;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gettext
    libtool
    itstool
    texinfo
    wrapPython
  ];

  buildInputs = [
    glib
    dotconf
    libsndfile
    libao
    libpulseaudio
    alsa-lib
    python
  ] ++ lib.optionals withEspeak [
    espeak
    sonic
    pcaudiolib
  ] ++ lib.optional withFlite [
    flite
  ] ++ lib.optional withPico [
    svox
  ];

  pythonPath = [
    pyxdg
  ];

  configureFlags = [
    # Audio method falls back from left to right.
    "--with-default-audio-method=\"libao,pulse,alsa,oss\""
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ] ++ lib.optional withPulse [
  "--with-pulse"
  ] ++ lib.optional withAlsa [
    "--with-alsa"
  ] ++ lib.optional withLibao [
    "--with-libao"
  ] ++ lib.optional withOss [
    "--with-oss"
  ] ++ lib.optional withEspeak [
    "--with-espeak-ng"
  ] ++ lib.optional withPico [
    "--with-pico"
  ];

  postPatch = ''
    substituteInPlace src/modules/pico.c --replace "/usr/share/pico/lang" "${svox}/share/pico/lang"
  '';

  postInstall = ''
    wrapPythonPrograms
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Common interface to speech synthesis";
    homepage = "https://devel.freebsoft.org/speechd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      berce
      jtojnar
    ];
    platforms = platforms.linux;
  };
}
