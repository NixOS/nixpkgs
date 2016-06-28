{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "hasklig-0.9";

  src = fetchurl {
    url = "https://github.com/i-tu/Hasklig/releases/download/0.9/Hasklig-0.9.zip";
    sha256 = "0rav55f6j1b8pqjgwvw52b92j2m630ampamlsiiym2xf684wnw2d";
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
