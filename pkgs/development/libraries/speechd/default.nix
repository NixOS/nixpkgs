{ stdenv, pkgconfig, fetchurl, python3Packages
, intltool, itstool, libtool, texinfo, autoreconfHook
, glib, dotconf, libsndfile
, withLibao ? true, libao
, withPulse ? false, libpulseaudio
, withAlsa ? false, alsaLib
, withOss ? false
, withFlite ? true, flite
# , withFestival ? false, festival-freebsoft-utils
, withEspeak ? true, espeak, sonic, pcaudiolib
, withPico ? true, svox
#, withIvona ? false # TODO: , libdumbtts
, withRhvoice ? true, rhvoice
}:

let
  inherit (stdenv.lib) optional optionals;
  inherit (python3Packages) python pyxdg wrapPython;

  # speechd hard-codes espeak, even when built without support for it.
  selectedDefaultModule =
    if withEspeak then
      "espeak-ng"
    else if withPico then
      "pico"
    else if withFlite then
      "flite"
    else if withRhvoice then
      "rhvoice"
    else
      throw "You need to enable at least one output module.";
in stdenv.mkDerivation rec {
  name = "speech-dispatcher-${version}";
  version = "0.8.8";

  src = fetchurl {
    url = "http://www.freebsoft.org/pub/projects/speechd/${name}.tar.gz";
    sha256 = "1wvck00w9ixildaq6hlhnf6wa576y02ac96lp6932h3k1n08jaiw";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook intltool libtool itstool texinfo wrapPython ];

  buildInputs = [ glib dotconf libsndfile libao libpulseaudio alsaLib python ]
    ++ optionals withEspeak [ espeak sonic pcaudiolib ]
    ++ optional withFlite flite
    ++ optional withPico svox
    ++ optional withRhvoice rhvoice
    # TODO: add flint/festival support with festival-freebsoft-utils package
    # ++ optional withFestival festival-freebsoft-utils
    # TODO: add Ivona support with libdumbtts package
    # ++ optional withIvona libdumbtts
  ;

  pythonPath = [ pyxdg ];

  configureFlags = [
    # Audio method falls back from left to right.
    "--with-default-audio-method=\"libao,pulse,alsa,oss\""
  ] ++ optional withPulse "--with-pulse"
    ++ optional withAlsa "--with-alsa"
    ++ optional withLibao "--with-libao"
    ++ optional withOss "--with-oss"
    ++ optional withEspeak "--with-espeak-ng"
    ++ optional withPico "--with-pico"
    # ++ optional withFestival "--with-flint"
    # ++ optional withIvona "--with-ivona"
  ;

  patches = [ ./set_nix_defaultModule.patch ]
    ++ optional withRhvoice [ ./add_rhvoice_module.patch ];

  postPatch = ''
    substituteInPlace src/modules/pico.c --replace "/usr/share/pico/lang" "${svox}/share/pico/lang"
    substituteInPlace config/speechd.conf --replace "nixDefault" "${selectedDefaultModule}"
    ${stdenv.lib.optionalString withRhvoice ''
      substituteInPlace config/speechd.conf --replace "sd_rhvoice" "${rhvoice}/bin/sd_rhvoice"
      substituteInPlace config/speechd.conf --replace "RHVoice.conf" "${rhvoice}/etc/RHVoice/RHVoice.conf"
    ''}
  '';

  postInstall = ''
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "Common interface to speech synthesis";
    homepage = https://devel.freebsoft.org/speechd;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ berce ];
    platforms = platforms.linux;
  };
}
