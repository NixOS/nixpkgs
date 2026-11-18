{
  lib,
  stdenv,
  fetchurl,
  fontforge,
  mkfontscale,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tamsyn-font";
  version = "1.11";

  src = fetchurl {
    url = "https://web.archive.org/web/20250824075220if_/http://www.fial.com/~scott/tamsyn-font/download/tamsyn-font-${finalAttrs.version}.tar.gz";
    hash = "sha256-l74bYERBtyVUjEVKkmA5k+uW5JP1CIRWOKhsjWT78k4=";
  };

  nativeBuildInputs = [
    fontforge
    mkfontscale
  ];

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

  meta = {
    description = "Monospace bitmap font aimed at programmers";
    longDescription = ''
      Tamsyn is a monospace bitmap font, primarily aimed at
      programmers. It was derived from Gilles Boccon-Gibod's MonteCarlo. Tamsyn
      font was further inspired by Gohufont, Terminus, Dina, Proggy, Fixedsys, and
      Consolas.
    '';
    license = lib.licenses.free;
    maintainers = [ ];
  };
})
