{ fetchurl, lib, stdenv, intltool, libtool, pkgconfig, glib, dotconf, libsndfile
, libao, python3Packages
, withEspeak ? false, espeak
, withPico ? true, svox
}:

stdenv.mkDerivation rec {
  name = "speech-dispatcher-${version}";
  version = "0.8.5";

  src = fetchurl {
    url = "http://www.freebsoft.org/pub/projects/speechd/${name}.tar.gz";
    sha256 = "18jlxnhlahyi6njc6l6576hfvmzivjjgfjyd2n7vvrvx9inphjrb";
  };

  buildInputs = [ intltool libtool glib dotconf libsndfile libao python3Packages.python ]
             ++ lib.optional withEspeak espeak
             ++ lib.optional withPico svox;
  nativeBuildInputs = [ pkgconfig python3Packages.wrapPython ];

  hardeningDisable = [ "format" ];

  pythonPath = with python3Packages; [ pyxdg ];

  postPatch = lib.optionalString withPico ''
    sed -i 's,/usr/share/pico/lang/,${svox}/share/pico/lang/,g' src/modules/pico.c
  '';

  postInstall = ''
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "Common interface to speech synthesis";
    homepage = http://www.freebsoft.org/speechd;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
