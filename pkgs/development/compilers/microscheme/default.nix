{ stdenv, fetchgit, vim, avrdude, avrgcclibc, makeWrapper }:

stdenv.mkDerivation rec {
  name = "microscheme-${version}";
  version = "2015-02-04";

  # externalize url/rev/sha256 to permit easier override
  rev = "2f14781034a67adc081a22728fbf47a632f4484e";
  sha256 = "15bdlmchzbhxj262r2fj78wm4c4hfrap4kyzv8n5b624svszr0zd";
  url = https://github.com/ryansuchocki/microscheme.git;

  src = fetchgit {
    inherit rev;
    inherit sha256;
    inherit url;
  };

  buildInputs = [ makeWrapper vim ];

  installPhase = ''
    mkdir -p $out/bin && make install PREFIX=$out

    mkdir -p $out/share/microscheme/
    cp -r examples/ $out/share/microscheme

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
