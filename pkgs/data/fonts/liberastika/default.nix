{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "liberastika-${version}";
  version = "1.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/lib-ka/liberastika-ttf-${version}.zip";
    sha256 = "0vg5ki120lb577ihvq8w0nxs8yacqzcvsmnsygksmn6281hyj0xj";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v $(find . -name '*.ttf') $out/share/fonts/truetype

    mkdir -p "$out/doc/${name}"
    cp -v AUTHORS ChangeLog COPYING README "$out/doc/${name}" || true
  '';

  meta = with stdenv.lib; {
    description = "Liberation Sans fork with improved cyrillic support";
    homepage = https://sourceforge.net/projects/lib-ka/;

    license = licenses.gpl2;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
