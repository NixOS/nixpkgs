{ lib, fetchzip }:

let
  version = "2.2";
in fetchzip rec {
  name = "comic-neue-${version}";

  url = "http://comicneue.com/${name}.zip";

  postFetch = ''
    mkdir -vp $out/share/{doc,fonts}
    unzip -j $downloadedFile comic-neue-2.2/\*.otf   -d $out/share/fonts/opentype
    unzip -j $downloadedFile comic-neue-2.2/\*.ttf   -d $out/share/fonts/truetype
    unzip -j $downloadedFile comic-neue-2.2/\*.eot   -d $out/share/fonts/EOT
    unzip -j $downloadedFile comic-neue-2.2/\*.woff  -d $out/share/fonts/WOFF
    unzip -j $downloadedFile comic-neue-2.2/\*.woff2 -d $out/share/fonts/WOFF2
    unzip -j $downloadedFile comic-neue-2.2/\*.pdf comic-neue-2.2/FONTLOG.txt comic-neue-2.2/OFL-FAQ.txt comic-neue-2.2/SIL-License.txt -d $out/share/doc/${name}
  '';

  sha256 = "1yypq5aqqzv3q1c6vx5130mi2iwihzzvrawhwqpwsfjl0p25sq9q";

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
