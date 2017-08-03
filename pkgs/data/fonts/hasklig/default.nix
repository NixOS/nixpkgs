{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "hasklig-${version}";
  version = "1.1";

  src = fetchurl {
    url = "https://github.com/i-tu/Hasklig/releases/download/${version}/Hasklig-${version}.zip";
    sha256 = "1hwmdbygallw2kjk0v3a3dl7w6b21wii3acrl0w3ibn05g1cxv4q";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp *.otf $out/share/fonts/opentype
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/i-tu/Hasklig;
    description = "A font with ligatures for Haskell code based off Source Code Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidrusu profpatsch ];
  };
}
