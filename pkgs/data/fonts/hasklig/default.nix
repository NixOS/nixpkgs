{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "hasklig-0.4";

  src = fetchurl {
    url = "https://github.com/i-tu/Hasklig/releases/download/0.4/Hasklig-0.4.zip";
    sha256 = "14j0zfapw6s6x5psp1rvx2i59rxdwb1jgwfgfhzhypr22qy40xi8";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp *.otf $out/share/fonts/opentype
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/i-tu/Hasklig";
    description = "A font with ligatures for Haskell code based off Source Code Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidrusu ];
  };
}
