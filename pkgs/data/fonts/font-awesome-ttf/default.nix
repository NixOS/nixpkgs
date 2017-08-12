{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "font-awesome-${version}";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner  = "FortAwesome";
    repo   = "Font-Awesome";
    rev    = "v${version}";
    sha256 = "0w30y26jp8nvxa3iiw7ayl6rkza1rz62msl9xw3srvxya1c77grc";
  };

  buildCommand = ''
    mkdir -p $out/share/fonts/truetype
    cp $src/fonts/*.ttf $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    description = "Font Awesome - TTF font";
    longDescription = ''
      Font Awesome gives you scalable vector icons that can instantly be customized.
      This package includes only the TTF font. For full CSS etc. see the project website.
    '';
    homepage = http://fortawesome.github.io/Font-Awesome/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ abaldeau ];
  };
}
