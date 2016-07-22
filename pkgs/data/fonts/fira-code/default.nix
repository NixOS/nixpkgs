{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "fira-code-${version}";
  version = "1.200";

  src = fetchurl {
    url = "https://github.com/tonsky/FiraCode/releases/download/${version}/FiraCode_${version}.zip";
    sha256 = "1zja7fsfh3xx2qv9wv46997d02l5nm483b5s39jpmxfracj8qam7";
  };

  sourceRoot = "otf";

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v *.otf $out/share/fonts/opentype
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tonsky/FiraCode;
    description = "Monospace font with programming ligatures";
    longDescription = ''
      Fira Code is a monospace font extending the Fira Mono font with
      a set of ligatures for common programming multi-character
      combinations.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
