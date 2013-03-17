{ stdenv, fetchurl, glibc }:
stdenv.mkDerivation rec {

  name = "ustr-${version}";
  version = "1.0.4";

  src = fetchurl {
    url = "http://www.and.org/ustr/${version}/${name}.tar.bz2";
    sha256 = "1i623ygdj7rkizj7985q9d6vj5amwg686aqb5j3ixpkqkyp6xbrx";
  };

  prePatch = "substituteInPlace Makefile --replace /usr/include/ ${glibc}/include/";

  patches = [ ./va_args.patch ]; # fixes bogus warnings that failed libsemanage

  makeFlags = "DESTDIR=$(out) prefix= LDCONFIG=echo";

  configurePhase = "make ustr-import";
  buildInputs = [ glibc ];

  meta = with stdenv.lib; {
    homepage = http://www.and.org/ustr/;
    description = "Micro String API for C language";
    license = licenses.bsd2;
    maintainers = [ maintainers.phreedom ];
  };
}
