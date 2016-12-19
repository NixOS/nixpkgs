{ stdenv, fetchurl, gawk, alsaLib, ncurses }:

stdenv.mkDerivation rec {
  name = "speech_tools-${version}";
  version = "2.1";

  src = fetchurl {
    url = "http://www.festvox.org/packed/festival/${version}/${name}-release.tar.gz";
    sha256 = "1s9bkfgdgyas8v2cr7x3dg0ck1xf9mn1q6a73gwy524sjb6nfqgz";
  };

  buildInputs = [ alsaLib ncurses ];

  preConfigure = ''
    sed -e s@/usr/bin/@@g -i $( grep -rl '/usr/bin/' . )
    sed -re 's@/bin/(rm|printf|uname)@\1@g' -i $( grep -rl '/bin/' . )
  '';

  installPhase = ''
    mkdir -p "$out"/{bin,lib}
    for d in bin lib; do
      for i in ./$d/*; do
        test "$(basename "$i")" = "Makefile" ||
          cp -r "$(readlink -f $i)" "$out/$d"
      done
    done
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Text-to-speech engine";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.free;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.festvox.org/packed/festival/";
    };
  };
}
