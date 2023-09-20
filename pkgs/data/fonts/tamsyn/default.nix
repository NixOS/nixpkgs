{ lib, stdenv, fetchurl, fontforge, xorg }:

let
  version = "1.11";
in stdenv.mkDerivation {
  pname = "tamsyn-font";
  inherit version;

  src = fetchurl {
    url = "http://www.fial.com/~scott/tamsyn-font/download/tamsyn-font-${version}.tar.gz";
    sha256 = "0kpjzdj8sv5871b8827mjgj9dswk75h94jj5iia2bds18ih1pglp";
   };

  nativeBuildInputs = [ fontforge xorg.mkfontscale ];

  unpackPhase = ''
    tar -xzf $src --strip-components=1
  '';

  postBuild = ''
    # convert pcf fonts to otb
    for i in *.pcf; do
      name=$(basename "$i" .pcf)
      fontforge -lang=ff -c "Open(\"$i\"); Generate(\"$name.otb\")"
    done

    # compress pcf fonts
    gzip -n -9 *.pcf
  '';

  installPhase = ''
    install -m 644 -D *.otb *.pcf.gz -t "$out/share/fonts/misc"
    install -m 644 -D *.psf.gz -t "$out/share/consolefonts"
    mkfontdir "$out/share/fonts/misc"
  '';

  meta = with lib; {
    description = "A monospace bitmap font aimed at programmers";
    longDescription = ''Tamsyn is a monospace bitmap font, primarily aimed at
    programmers. It was derived from Gilles Boccon-Gibod's MonteCarlo. Tamsyn
    font was further inspired by Gohufont, Terminus, Dina, Proggy, Fixedsys, and
    Consolas.
    '';
    homepage = "http://www.fial.com/~scott/tamsyn-font/";
    downloadPage = "http://www.fial.com/~scott/tamsyn-font/download";
    license = licenses.free;
    maintainers = [ maintainers.rps ];
  };
}

