{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "andika";
  version = "5.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/andika/Andika-${version}.zip";
    sha256 = "0ds0g3wh685ifp6aip8nanw2x7mxi13rbpv3pjhchnjb9g6lk6yp";
  };

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
