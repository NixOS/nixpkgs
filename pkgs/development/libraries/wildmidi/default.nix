{ stdenv, fetchurl, cmake, alsaLib, freepats }:

stdenv.mkDerivation rec {
  name = "wildmidi-0.4.3";

  src = fetchurl {
    url = "https://github.com/Mindwerks/wildmidi/archive/${name}.tar.gz";
    sha256 = "1igkxv4axnqap59d8pjgqj94x0khn3fdd2hq6wdvkd2v8nb5m3j9";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ alsaLib stdenv.cc.libc/*couldn't find libm*/ ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace /etc/wildmidi $out/etc
  '';

  postInstall = ''
    mkdir "$out"/etc
    echo "dir ${freepats}" > "$out"/etc/wildmidi.cfg
    echo "source ${freepats}/freepats.cfg" >> "$out"/etc/wildmidi.cfg
  '';

  meta = with stdenv.lib; {
    description = "Software MIDI player and library";
    longDescription = ''
      WildMIDI is a simple software midi player which has a core softsynth
      library that can be use with other applications.
    '';
    homepage = http://wildmidi.sourceforge.net/;
    # The library is LGPLv3, the wildmidi executable is GPLv3
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
