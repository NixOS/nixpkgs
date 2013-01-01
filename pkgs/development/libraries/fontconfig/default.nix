{ stdenv, fetchurl, pkgconfig, freetype, expat }:

stdenv.mkDerivation rec {
  name = "fontconfig-2.10.1";

  src = fetchurl {
    url = "http://fontconfig.org/release/${name}.tar.gz";
    sha256 = "08h252crb3aqciwdk81jypmz2i7618dzqn3zlr87w1f017wjp4f3";
  };

  buildInputs = [ pkgconfig freetype ];

  propagatedBuildInputs = [ expat ]; # !!! shouldn't be necessary, but otherwise pango breaks

  configureFlags = "--with-confdir=/etc/fonts --with-cache-dir=/var/cache/fontconfig --disable-docs --with-default-fonts=";

  # We should find a better way to access the arch reliably.
  crossArch = stdenv.cross.arch or null;

  preConfigure = ''
    if test -n "$crossConfig"; then
      configureFlags="$configureFlags --with-arch=$crossArch";
    fi
  '';

  enableParallelBuilding = true;

  # Don't try to write to /etc/fonts or /var/cache/fontconfig at install time.
  installFlags = "CONFDIR=$(out)/etc/fonts RUN_FC_CACHE_TEST=false fc_cachedir=$(TMPDIR)/dummy";

  meta = {
    description = "A library for font customization and configuration";
    homepage = http://fontconfig.org/;
    license = "bsd";
  };
}
