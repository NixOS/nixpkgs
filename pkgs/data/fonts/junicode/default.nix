{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "junicode-0.7.8";

  src = fetchurl {
    url = mirror://sourceforge/junicode/junicode/junicode-0-7-8/junicode-0-7-8.zip;
    sha256 = "1lgkhj52s351ya7lp9z3xba7kaivgdvg80njhpj1rpc3jcmc69vl";
  };

  buildInputs = [ unzip ];

  installPhase =
    ''
      mkdir -p $out/share/fonts/junicode-ttf
      cp fonts/*.ttf $out/share/fonts/junicode-ttf
    '';

  meta = {
    homepage = http://junicode.sourceforge.net/;
    description = "A Unicode font";
    platforms = stdenv.lib.platforms.unix;
  };
}
