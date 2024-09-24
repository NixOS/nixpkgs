{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "andika";
  version = "6.200";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/andika/Andika-${version}.zip";
    hash = "sha256-Ge+Yq3+1IJ+mXhjw7Vtpu5DIWiMfwOdEH/S1RSzYh3A=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 OFL.txt OFL-FAQ.txt README.txt FONTLOG.txt -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://software.sil.org/andika";
    description = "Family designed especially for literacy use taking into account the needs of beginning readers";
    longDescription = ''
      Andika is a sans serif, Unicode-compliant font designed especially for literacy use, taking into account the needs of beginning readers. The focus is on clear, easy-to-perceive letterforms that will not be readily confused with one another.

      A sans serif font is preferred by some literacy personnel for teaching people to read. Its forms are simpler and less cluttered than those of most serif fonts. For years, literacy workers have had to make do with fonts that were not really suitable for beginning readers and writers. In some cases, literacy specialists have had to tediously assemble letters from a variety of fonts in order to get all of the characters they need for their particular language project, resulting in confusing and unattractive publications. Andika addresses those issues.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.f--t ];
  };
}
