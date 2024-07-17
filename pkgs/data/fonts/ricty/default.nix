{
  lib,
  stdenv,
  fetchurl,
  google-fonts,
  migu,
  fontforge,
  which,
}:

stdenv.mkDerivation rec {
  pname = "ricty";
  version = "4.1.1";

  src = fetchurl {
    url = "https://rictyfonts.github.io/files/ricty_generator-${version}.sh";
    sha256 = "03fngb8f5hl7ifigdm5yljhs4z2x80cq8y8kna86d07ghknhzgw6";
  };

  unpackPhase = ''
    install -m 0770 $src ricty_generator.sh
  '';

  patchPhase = ''
    sed -i 's/fonts_directories=".*"/fonts_directories="$inconsolata $migu"/' ricty_generator.sh
  '';

  buildInputs = [
    google-fonts
    migu
    fontforge
    which
  ];

  buildPhase = ''
    inconsolata=${google-fonts} migu=${migu} ./ricty_generator.sh auto
  '';

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/ricty -D Ricty-*.ttf
  '';

  meta = with lib; {
    description = "A high-quality Japanese font based on Inconsolata and Migu 1M";
    homepage = "https://rictyfonts.github.io";
    license = licenses.unfree;
    maintainers = [ maintainers.mikoim ];
  };
}
