{stdenv, fetchurl, freetype, expat}:

assert freetype != null && expat != null;

stdenv.mkDerivation {
  name = "fontconfig-2.5.0";
  
  src = fetchurl {
    url = http://fontconfig.org/release/fontconfig-2.5.0.tar.gz;
    sha256 = "1zhfvxgslgpnlz13ksiq90jgl0747n81c1nkg5klksxp9kdvmiil";
  };
  
  buildInputs = [freetype];
  propagatedBuildInputs = [expat]; # !!! shouldn't be necessary, but otherwise pango breaks

  preConfigure = ''
    configureFlags="--with-confdir=$out/etc/fonts --disable-docs --with-default-fonts="
  '';

  meta = {
    description = "A library for font customization and configuration";
    homepage = http://fontconfig.org/;
  };  
}
