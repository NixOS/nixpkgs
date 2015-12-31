{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "fira-code-${version}";
  version = "1.101";

  src = fetchurl {
    url = "https://github.com/tonsky/FiraCode/releases/download/${version}/FiraCode_${version}.zip";
    sha256 = "0wbjk4cyibyjp7kjvwnm7as1ch312zwjbi469v26sl41svf53s5v";
  };

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
