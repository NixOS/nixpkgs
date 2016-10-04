{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "hasklig-${version}";
  version = "0.9";

  src = fetchurl {
    url = "https://github.com/i-tu/Hasklig/releases/download/${version}/Hasklig-${version}.zip";
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
    maintainers = with maintainers; [ davidrusu profpatsch ];
  };
}
