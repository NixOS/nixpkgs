{stdenv, fetchurl, openssl, perl}:

stdenv.mkDerivation rec {
  name = "ldns-1.6.16";

  src = fetchurl {
    url = "http://www.nlnetlabs.nl/downloads/ldns/${name}.tar.gz";
    sha256 = "15gn9m95r6sq2n55dw4r87p2aljb5lvy1w0y0br70wbr0p5zkci4";
  };

  patchPhase = ''
    sed -i 's,\$(srcdir)/doc/doxyparse.pl,perl $(srcdir)/doc/doxyparse.pl,' Makefile.in
  '';

  buildInputs = [ openssl perl ];

  configureFlags = [ "--with-ssl=${openssl}" "--with-drill" ];

  meta = {
    description = "Library with the aim of simplifying DNS programming in C";
    license = "BSD";
    homepage = "http://www.nlnetlabs.nl/projects/ldns/";
  };
}
