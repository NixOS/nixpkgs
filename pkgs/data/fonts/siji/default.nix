{ stdenv, fetchzip }:

let
  date = "2016-05-13";
in fetchzip {
  name = "siji-${date}";

  url = https://github.com/stark/siji/archive/95369afac3e661cb6d3329ade5219992c88688c1.zip;

  postFetch = ''
    unzip -j $downloadedFile

    install -D *.pcf -t $out/share/fonts/pcf
    install -D *.bdf -t $out/share/fonts/bdf
  '';

  sha256 = "1ymcbirdbkqaf0xs2y00l0wachb4yxh1fgqm5avqwvccs0lsfj1d";

  meta = {
    homepage = https://github.com/stark/siji;
    description = "An iconic bitmap font based on Stlarch with additional glyphs";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.asymmetric ];
  };
}
