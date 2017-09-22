{stdenv, fetchzip}:

let
  version = "2.004";
in fetchzip rec {
  name = "comfortaa-${version}";

  url = "http://openfontlibrary.org/assets/downloads/comfortaa/38318a69b56162733bf82bc0170b7521/comfortaa.zip";
  postFetch = ''
    mkdir -p $out/share/fonts $out/share/doc
    unzip -l $downloadedFile
    unzip -j $downloadedFile \*.ttf                        -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*/FONTLOG.txt \*/donate.html -d $out/share/doc/${name}
  '';
  sha256 = "1gnscf3kw9p5gbc5594a22cc6nmiir9mhp1nl3mkbzd4v1jfbh2h";

  meta = with stdenv.lib; {
    homepage = http://aajohan.deviantart.com/art/Comfortaa-font-105395949;
    description = "A clean and modern font suitable for headings and logos";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
