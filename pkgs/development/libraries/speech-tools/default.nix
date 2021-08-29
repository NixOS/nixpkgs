{ lib, stdenv, fetchurl, alsaLib, ncurses }:

stdenv.mkDerivation rec {
  name = "speech_tools-${version}.0";
  version = "2.5";

  src = fetchurl {
    url = "http://www.festvox.org/packed/festival/${version}/${name}-release.tar.gz";
    sha256 = "1k2xh13miyv48gh06rgsq2vj25xwj7z6vwq9ilsn8i7ig3nrgzg4";
  };

  buildInputs = [ alsaLib ncurses ];

  preConfigure = ''
    sed -e s@/usr/bin/@@g -i $( grep -rl '/usr/bin/' . )
    sed -re 's@/bin/(rm|printf|uname)@\1@g' -i $( grep -rl '/bin/' . )

    # c99 makes isnan valid for float and double
    substituteInPlace include/EST_math.h \
      --replace '__isnanf(X)' 'isnan(X)'
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

  doCheck = true;

  checkTarget = "test";

  meta = with lib; {
    description = "Text-to-speech engine";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.free;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://www.festvox.org/packed/festival/";
    };
  };
}
