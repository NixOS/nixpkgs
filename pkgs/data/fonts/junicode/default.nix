{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "junicode-0.6.15";

  src = fetchurl {
    url = mirror://sourceforge/junicode/junicode-0.6.15.zip;
    sha256 = "0p16r5s6qwyz0hayb6k61s5r2sfachlx7r6gpqqx5myx6ipbfdns";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase =
    ''
      mkdir -p $out/share/fonts/junicode-ttf
      cp *.ttf $out/share/fonts/junicode-ttf
    '';

  meta = {
    description = "A Unicode font";
  };
}
