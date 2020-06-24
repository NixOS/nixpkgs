{ lib, mkFont, fetchurl, fontforge, mkfontscale }:

mkFont rec {
  pname = "tamsyn-font";
  version = "1.11";

  src = fetchurl {
    url = "https://www.fial.com/~scott/tamsyn-font/download/${pname}-${version}.tar.gz";
    sha256 = "0kpjzdj8sv5871b8827mjgj9dswk75h94jj5iia2bds18ih1pglp";
   };

  nativeBuildInputs = [ fontforge mkfontscale ];

  dontBuild = false;
  buildPhase = ''
    # convert pcf fonts to otb
    for i in *.pcf; do
      name=$(basename "$i" .pcf)
      fontforge -lang=ff -c "Open(\"$i\"); Generate(\"$name.otb\")"
    done

    # compress pcf fonts
    gzip -n -9 *.pcf
  '';

  meta = with lib; {
    description = "A monospace bitmap font aimed at programmers";
    longDescription = ''Tamsyn is a monospace bitmap font, primarily aimed at
    programmers. It was derived from Gilles Boccon-Gibod's MonteCarlo. Tamsyn
    font was further inspired by Gohufont, Terminus, Dina, Proggy, Fixedsys, and
    Consolas.
    '';
    homepage = "https://www.fial.com/~scott/tamsyn-font/";
    downloadPage = "https://www.fial.com/~scott/tamsyn-font/download";
    license = licenses.free;
    maintainers = with maintainers; [ rps ];
  };
}

