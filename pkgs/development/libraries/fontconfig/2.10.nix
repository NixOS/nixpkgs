{ stdenv, fetchurl, pkgconfig, freetype, expat }:

stdenv.mkDerivation rec {
  name = "fontconfig-2.10.2";

  src = fetchurl {
    url = "http://fontconfig.org/release/${name}.tar.bz2";
    sha256 = "0llraqw86jmw4vzv7inskp3xxm2gc64my08iwq5mzncgfdbfza4f";
  };

  patches = [
    # FreeType 2.7 prefixes PCF font family names with the foundry name.
    # The output of fc-list and fc-query change which breaks the tests.
    ./test-pcf-family-names-freetype-2.7.patch
  ];

  outputs = [ "bin" "dev" "lib" "out" ]; # $out contains all the config

  propagatedBuildInputs = [ freetype ];
  buildInputs = [ pkgconfig expat ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-cache-dir=/var/cache/fontconfig"
    "--disable-docs"
    "--with-default-fonts="
  ];

  # We should find a better way to access the arch reliably.
  crossArch = stdenv.cross.arch or null;

  preConfigure = ''
    if test -n "$crossConfig"; then
      configureFlags="$configureFlags --with-arch=$crossArch";
    fi
  '';

  enableParallelBuilding = true;

  doCheck = true;

  # Don't try to write to /var/cache/fontconfig at install time.
  installFlags = "sysconfdir=$(out)/etc fc_cachedir=$(TMPDIR)/dummy RUN_FC_CACHE_TEST=false";

  passthru = {
    # Empty for backward compatibility, there was no versioning before 2.11
    configVersion = "";
  };

  meta = with stdenv.lib; {
    description = "A library for font customization and configuration";
    homepage = http://fontconfig.org/;
    license = licenses.bsd2; # custom but very bsd-like
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
