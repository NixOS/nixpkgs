{ lib, fetchzip }:

let
  version = "2.3";
in fetchzip rec {
  name = "comic-neue-${version}";

  url = "http://comicneue.com/${name}.zip";

  postFetch = ''
    mkdir -vp $out/share/{doc,fonts}
    unzip -j $downloadedFile OTF/\*.otf   -d $out/share/fonts/opentype
    unzip -j $downloadedFile Web/\*.ttf   -d $out/share/fonts/truetype
    unzip -j $downloadedFile Web/\*.eot   -d $out/share/fonts/EOT
    unzip -j $downloadedFile Web/\*.woff  -d $out/share/fonts/WOFF
    unzip -j $downloadedFile Web/\*.woff2 -d $out/share/fonts/WOFF2
    unzip -j $downloadedFile \*.pdf FONTLOG.txt OFL-FAQ.txt SIL-License.txt -d $out/share/doc/${name}
  '';

  sha256 = "1gs4vhys0m3qsw06qaxzyi81f06w5v66kbyl64yw3pq2rb656779";

  meta = with lib; {
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
