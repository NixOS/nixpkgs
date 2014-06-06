{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "gyre-fonts";

  src = fetchurl {
    url = "http://www.gust.org.pl/projects/e-foundry/tex-gyre/whole/tg-2.005otf.zip";
    sha256 = "0kph9l3g7jb2bpmxdbdg5zl56wacmnvdvsdn7is1gc750sqvsn31";
  };

  buildInputs = [unzip];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.otf $out/share/fonts/truetype
  '';

  meta = {
    description = "OpenType fonts from the Gyre project, suitable for use with (La)TeX";

    longDescription = ''The Gyre project started in 2006, and will
    eventually include enhanced releases of all 35 freely available
    PostScript fonts distributed with Ghostscript v4.00.  These are
    being converted to OpenType and extended with diacritical marks
    covering all modern European languages and then some'';

    homepage = "http://www.gust.org.pl/projects/e-foundry/tex-gyre/index_html#Readings";

    # GUST Font License: http://www.gust.org.pl/projects/e-foundry/licenses
    license = "unknown";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ "Daniel Bergey <bergey@teallabs.org>" ];
  };
}
