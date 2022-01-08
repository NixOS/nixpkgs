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
# , withFestival ? false, festival-freebsoft-utils
, withEspeak ? true, espeak, sonic, pcaudiolib
, withPico ? true, svox
# , withIvona ? false, libdumbtts
}:

let
  inherit (lib) optional optionals;
  inherit (python3Packages) python pyxdg wrapPython;
in stdenv.mkDerivation rec {
  pname = "speech-dispatcher";
  version = "0.11.1";

  src = fetchurl {
    url = "https://github.com/brailcom/speechd/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-0doS7T2shPE3mbai7Dm6LTyiGoST9E3BhVvQupbC3cY=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      utillinux = util-linux;
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
  ] ++ optionals withEspeak [
    espeak
    sonic
    pcaudiolib
  ] ++ optional withFlite flite
    ++ optional withPico svox
    # TODO: add flint/festival support with festival-freebsoft-utils package
    # ++ optional withFestival festival-freebsoft-utils
    # TODO: add Ivona support with libdumbtts package
    # ++ optional withIvona libdumbtts
  ;

  pythonPath = [ pyxdg ];

  configureFlags = [
    # Audio method falls back from left to right.
    "--with-default-audio-method=\"libao,pulse,alsa,oss\""
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ] ++ optional withPulse "--with-pulse"
    ++ optional withAlsa "--with-alsa"
    ++ optional withLibao "--with-libao"
    ++ optional withOss "--with-oss"
    ++ optional withEspeak "--with-espeak-ng"
    ++ optional withPico "--with-pico"
    # ++ optional withFestival "--with-flint"
    # ++ optional withIvona "--with-ivona"
  ;

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
