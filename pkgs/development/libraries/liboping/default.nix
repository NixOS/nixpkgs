{ stdenv, fetchurl, ncurses ? null, perl ? null }:

stdenv.mkDerivation rec {
  name = "liboping-1.8.0";

  src = fetchurl {
    url = "http://verplant.org/liboping/files/${name}.tar.bz2";
    sha256 = "1nsvlsvapc64h0anip2hz5ydbgk3an94xqiaa9kivcw1r6193jqx";
  };

  buildInputs = [ ncurses perl ];

  configureFlags = stdenv.lib.optionalString (perl == null) "--with-perl-bindings=no";

  meta = with stdenv.lib; {
    description = "C library to generate ICMP echo requests (a.k.a. ping packets)";
    longDescription = ''
      liboping is a C library to generate ICMP echo requests, better known as
      "ping packets". It is intended for use in network monitoring applications
      or applications that would otherwise need to fork ping(1) frequently.
      Included is a sample application, called oping, which demonstrates the
      library's abilities.
    '';
    homepage = http://noping.cc/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
