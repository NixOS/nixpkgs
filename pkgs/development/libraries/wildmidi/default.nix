{ stdenv, fetchurl, alsaLib, freepats }:

stdenv.mkDerivation rec {
  name = "wildmidi-0.2.3.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/wildmidi/wildmidi/${name}.tar.gz";
    sha256 = "0m75753mn0rbwja180c2qk53s149wp4k35dijr2i6pa7sc12fr00";
  };

  # NOTE: $out in configureFlags, like this:
  #   configureFlags = "--disable-werror --with-wildmidi-cfg=$out/etc/wildmidi.cfg";
  # is not expanded, so use this workaround:
  preConfigure = ''
    configureFlags="--disable-werror --with-wildmidi-cfg=$out/etc/wildmidi.cfg"
  '';

  buildInputs = [ alsaLib ];

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
    maintainers = [maintainers.bjornfor];
  };
}
