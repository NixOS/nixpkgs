{stdenv, fetchurl, openssl, perl}:

stdenv.mkDerivation {
  name = "ldns-1.6.11";
  src = fetchurl {
    url = "http://www.nlnetlabs.nl/downloads/ldns/ldns-1.6.11.tar.gz";
    sha256 = "1248c9gkgfmjdmpp3lfd56vvln94ii54kbxa5iykxvcxivmbi4b8";
  };

  patchPhase = ''
    sed -i 's,\$(srcdir)/doc/doxyparse.pl,perl $(srcdir)/doc/doxyparse.pl,' Makefile.in
  '';

  buildInputs = [ openssl perl ];

  configureFlags = [ "--with-ssl=${openssl}" ];

  meta = {
    description = "Library with the aim of simplifying DNS programming in C";
    license = "BSD";
    homepage = "http://www.nlnetlabs.nl/projects/ldns/";
  };
}
