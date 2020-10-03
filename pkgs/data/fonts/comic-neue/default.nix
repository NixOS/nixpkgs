{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "comic-neue";
  version = "2.5";

  src = fetchzip {
    url = "http://comicneue.com/${pname}-${version}.zip";
    sha256 = "1kc0yyha6cc584vcl9z1cq1z6prgkxk93g75mr8gapfdrj25dp3q";
    stripRoot = false; # because it comes with a __MACOSX directory
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -pv $out/share/{doc/${pname}-${version},fonts/{opentype,truetype,EOT,WOFF,WOFF2}}
    cp -v ${pname}-${version}/{FONTLOG,OFL-FAQ,OFL}.txt $out/share/doc/
    cp -v ${pname}-${version}/OTF/ComicNeue-Angular/*.otf $out/share/fonts/opentype
    cp -v ${pname}-${version}/OTF/ComicNeue/*.otf $out/share/fonts/opentype
    cp -v ${pname}-${version}/TTF/ComicNeue-Angular/*.ttf $out/share/fonts/truetype
    cp -v ${pname}-${version}/TTF/ComicNeue/*.ttf $out/share/fonts/truetype
    cp -v ${pname}-${version}/WebFonts/eot/ComicNeue-Angular/*.eot $out/share/fonts/EOT
    cp -v ${pname}-${version}/WebFonts/eot/ComicNeue/*.eot $out/share/fonts/EOT
    cp -v ${pname}-${version}/WebFonts/woff/ComicNeue-Angular/*.woff $out/share/fonts/WOFF
    cp -v ${pname}-${version}/WebFonts/woff/ComicNeue/*.woff $out/share/fonts/WOFF
    cp -v ${pname}-${version}/WebFonts/woff2/ComicNeue/*.woff2 $out/share/fonts/WOFF2

    # Quick fix for conflicting names in upstream
    for i in ${pname}-${version}/WebFonts/woff2/ComicNeue-Angular/*.woff2; do
      cp -v $i $out/share/fonts/WOFF2/`basename $i|sed -e 's|ComicNeue|ComicNeue-Angular|'`
    done
  '';

  meta = with stdenv.lib; {
    homepage = "http://comicneue.com/";
    description = "A casual type face: Make your lemonade stand look like a fortune 500 company";
    longDescription = ''
      ComicNeue is inspired by Comic Sans but more regular. It was
      designed by Craig Rozynski. It is available in two variants:
      Comic Neue and Comic Neue Angular. The former having round and
      the latter angular terminals. Both variants come in Light,
      Regular, and Bold weights with Oblique variants.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
