{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "font-awesome-4.4.0";

  src = fetchurl {
    url = "http://fortawesome.github.io/Font-Awesome/assets/${name}.zip";
    sha256 = "1bmjh3j533awihdxihvlk2d1ypzs9q7azj0viqbm0df8jj2v4rwq";
  };

  buildCommand = ''
    ${unzip}/bin/unzip $src
    mkdir -p $out/share/fonts/truetype
    cp */fonts/*.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "Font Awesome - TTF font";
    longDescription = ''
      Font Awesome gives you scalable vector icons that can instantly be customized.
      This package includes only the TTF font. For full CSS etc. see the project website.
    '';
    homepage = "http://fortawesome.github.io/Font-Awesome/";
    license = stdenv.lib.licenses.ofl;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.abaldeau ];
  };
}
