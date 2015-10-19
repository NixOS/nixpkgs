{stdenv, fetchurl, libssl, perl}:

stdenv.mkDerivation rec {
  name = "ldns-1.6.17";

  src = fetchurl {
    url = "http://www.nlnetlabs.nl/downloads/ldns/${name}.tar.gz";
    sha256 = "1kf8pkwhcssvgzhh6ha1pjjiziwvwmfaali7kaafh6118mcy124b";
  };

  patches = [ ./perl-5.22-compat.patch ];

  postPatch = ''
    patchShebangs doc/doxyparse.pl
  '';

  nativeBuildInputs = [ perl ];
  buildInputs = [ libssl ];

  configureFlags = [ "--with-ssl=${libssl}" "--with-drill" ];

  meta = with stdenv.lib; {
    description = "Library with the aim of simplifying DNS programming in C";
    license = licenses.bsd3;
    homepage = "http://www.nlnetlabs.nl/projects/ldns/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
