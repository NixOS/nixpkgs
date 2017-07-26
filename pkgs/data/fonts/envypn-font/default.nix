{ stdenv, fetchurl, mkfontdir, mkfontscale }:

stdenv.mkDerivation rec {
  name = "envypn-font-1.7.1";

  src = fetchurl {
    url = "https://ywstd.fr/files/p/envypn-font/envypn-font-1.7.1.tar.gz";
    sha256 = "bda67b6bc6d5d871a4d46565d4126729dfb8a0de9611dae6c68132a7b7db1270";
  };

  buildInputs = [ mkfontdir mkfontscale ];

  unpackPhase = ''
    tar -xzf $src --strip-components=1
  '';

  installPhase = ''
    # install the pcf fonts (for xorg applications)
    fontDir="$out/share/fonts/envypn"
    mkdir -p "$fontDir"
    mv *.pcf.gz "$fontDir"

    cd "$fontDir"
    mkfontdir
    mkfontscale
  '';

  meta = with stdenv.lib; {
    description = ''
      Readable bitmap font inspired by Envy Code R
    '';
    homepage = "http://ywstd.fr/p/pj/#envypn";
    license = licenses.miros;
    platforms = platforms.linux;
  };
}
