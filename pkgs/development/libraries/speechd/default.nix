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
# , withIvona ? false, libdumbtts
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
    else
      throw "You need to enable at least one output module.";
in stdenv.mkDerivation rec {
  pname = "speech-dispatcher";
  version = "0.8.8";

  src = fetchurl {
    url = "http://www.freebsoft.org/pub/projects/speechd/${pname}-${version}.tar.gz";
    sha256 = "1wvck00w9ixildaq6hlhnf6wa576y02ac96lp6932h3k1n08jaiw";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook intltool libtool itstool texinfo wrapPython ];

  buildInputs = [ glib dotconf libsndfile libao libpulseaudio alsaLib python ]
    ++ optionals withEspeak [ espeak sonic pcaudiolib ]
    ++ optional withFlite flite
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
    substituteInPlace config/speechd.conf --replace "DefaultModule espeak" "DefaultModule ${selectedDefaultModule}"
    substituteInPlace src/modules/pico.c --replace "/usr/share/pico/lang" "${svox}/share/pico/lang"
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
