{ stdenv, fetchzip, vim, avrdude, avrgcclibc, makeWrapper }:

stdenv.mkDerivation rec {
  name = "microscheme-${version}";
  version = "0.9.2";

  src = fetchzip {
    name = "${name}-src";
    url = "https://github.com/ryansuchocki/microscheme/archive/v${version}.tar.gz";
    sha256 = "0ly1cphvnsip70kng9q0blb07pkyp9allav42sr6ybswqfqg60j9";
  };

  buildInputs = [ makeWrapper vim ];

  installPhase = ''
    make install PREFIX=$out

    wrapProgram $out/bin/microscheme \
      --prefix PATH : "${avrdude}/bin:${avrgcclibc}/bin"
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
