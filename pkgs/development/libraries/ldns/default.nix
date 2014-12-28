{stdenv, fetchurl, openssl, perl}:

stdenv.mkDerivation rec {
  name = "ldns-1.6.17";

  src = fetchurl {
    url = "http://www.nlnetlabs.nl/downloads/ldns/${name}.tar.gz";
    sha256 = "1kf8pkwhcssvgzhh6ha1pjjiziwvwmfaali7kaafh6118mcy124b";
  };

  patchPhase = ''
    sed -i 's,\$(srcdir)/doc/doxyparse.pl,perl $(srcdir)/doc/doxyparse.pl,' Makefile.in
  '';

  buildInputs = [ openssl perl ];

  configureFlags = [ "--with-ssl=${openssl}" "--with-drill" ];

  meta = {
    description = "Library with the aim of simplifying DNS programming in C";
    license = stdenv.lib.licenses.bsd3;
    homepage = "http://www.nlnetlabs.nl/projects/ldns/";
  };
}
