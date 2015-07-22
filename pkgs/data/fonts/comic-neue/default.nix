{ stdenv, fetchurl
, unzip }:

stdenv.mkDerivation rec {
  name = "comic-neue-${version}";
  version = "2.2";

  src = fetchurl {
    url = "http://comicneue.com/${name}.zip";
    sha256 = "1dmmjhxxc0bj2755yksiiwh275vmnyciknr9b995lmdkjgh7sz6n";
  };

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];
  sourceRoot = name;

  installPhase = ''
    mkdir -vp $out/share/fonts/truetype $out/share/fonts/opentype $out/share/fonts/EOT $out/share/fonts/WOFF $out/share/fonts/WOFF2 $out/share/doc/${name}
    cp -v OTF/*.otf  $out/share/fonts/opentype
    cp -v Web/*.ttf $out/share/fonts/truetype
    cp -v Web/*.eot  $out/share/fonts/EOT
    cp -v Web/*.woff  $out/share/fonts/WOFF
    cp -v Web/*.woff2  $out/share/fonts/WOFF2
    cp -v Booklet-ComicNeue.pdf FONTLOG.txt OFL-FAQ.txt SIL-License.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = http://comicneue.com/;
    description = "A casual type face: Make your lemonade stand look like a fortune 500 company";
    longDescription = ''
      It is inspired by Comic Sans but more regular.  The font was
      designed by Craig Rozynski.  It is available in two variants:
      Comic Neue and Comic Neue Angular.  The former having round and
      the latter angular terminals.  Both variants come in Light,
      Regular, and Bold weights with Oblique variants.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
