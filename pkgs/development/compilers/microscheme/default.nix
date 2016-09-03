{ stdenv, fetchzip, vim, avrdude, avrgcclibc, makeWrapper }:

stdenv.mkDerivation rec {
  name = "microscheme-${version}";
  version = "0.9.3";

  src = fetchzip {
    name = "${name}-src";
    url = "https://github.com/ryansuchocki/microscheme/archive/v${version}.tar.gz";
    sha256 = "1r3ng4pw1s9yy1h5rafra1rq19d3vmb5pzbpcz1913wz22qdd976";
  };

  buildInputs = [ makeWrapper vim ];

  installPhase = ''
    make install PREFIX=$out

    wrapProgram $out/bin/microscheme \
      --prefix PATH : "${stdenv.lib.makeBinPath [ avrdude avrgcclibc ]}"
  '';

  meta = with stdenv.lib; {
    homepage = http://microscheme.org;
    description = "A Scheme subset for Atmel microcontrollers";
    longDescription = ''
      Microscheme is a Scheme subset/variant designed for Atmel
      microcontrollers, especially as found on Arduino boards.
    '';
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ardumont ];
  };
}
