{ lib, fetchzip }:

let
  version = "6.101";
in
  fetchzip rec {
    name = "andika-${version}";

    url = "https://software.sil.org/downloads/r/andika/Andika-${version}.zip";

    postFetch = ''
      mkdir -p $out/share/{doc,fonts}
      unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
      unzip -j $downloadedFile \*OFL.txt \*OFL-FAQ.txt \*README.txt \*FONTLOG.txt -d "$out/share/doc/${name}"
    '';

    sha256 = "sha256-J/Ad+fmCMOxLoo+691LE6Bgi/l3ovIfWScwwVWtqACI=";

    meta = with lib; {
      homepage = "https://software.sil.org/andika";
      description = "A family designed especially for literacy use taking into account the needs of beginning readers";
      longDescription = ''
      Andika is a sans serif, Unicode-compliant font designed especially for literacy use, taking into account the needs of beginning readers. The focus is on clear, easy-to-perceive letterforms that will not be readily confused with one another.

      A sans serif font is preferred by some literacy personnel for teaching people to read. Its forms are simpler and less cluttered than those of most serif fonts. For years, literacy workers have had to make do with fonts that were not really suitable for beginning readers and writers. In some cases, literacy specialists have had to tediously assemble letters from a variety of fonts in order to get all of the characters they need for their particular language project, resulting in confusing and unattractive publications. Andika addresses those issues.
      '';
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = [ maintainers.f--t ];
    };
  }
