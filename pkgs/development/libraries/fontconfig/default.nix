{stdenv, fetchurl, freetype, expat}:

stdenv.mkDerivation rec {
  name = "fontconfig-2.7.3";
  
  src = fetchurl {
    url = "http://fontconfig.org/release/${name}.tar.gz";
    sha256 = "0l5hjifapv4v88a204ixg6w6xly81cji2cr65znra0vbbkqvz3xs";
  };
  
  buildInputs = [freetype];
  propagatedBuildInputs = [expat]; # !!! shouldn't be necessary, but otherwise pango breaks

  configureFlags = "--with-confdir=/etc/fonts --with-cache-dir=/var/cache/fontconfig --disable-docs --with-default-fonts=";

  installFlags = "CONFDIR=$(out)/etc RUN_FC_CACHE_TEST=false";

  meta = {
    description = "A library for font customization and configuration";
    homepage = http://fontconfig.org/;
    license = "bsd";
  };  
}
