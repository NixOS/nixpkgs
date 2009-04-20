{stdenv, fetchurl, freetype, expat}:

stdenv.mkDerivation {
  name = "fontconfig-2.6.0";
  
  src = fetchurl {
    url = http://fontconfig.org/release/fontconfig-2.6.0.tar.gz;
    sha256 = "19fqr2vh7rzpqfh2lnkymh7q5pxn9r4w2z35lh36crp5l3m3k9m9";
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
