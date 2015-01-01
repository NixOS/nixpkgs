{ stdenv, fetchurl, pkgconfig, flex, yacc, readline, openldap, libcap_ng
, sqlite, db, ncurses, openssl, cyrus_sasl
}:

stdenv.mkDerivation rec {
  name = "heimdal-1.5.3";

  src = fetchurl {
    urls = [
      "http://www.h5l.org/dist/src/${name}.tar.gz"
      "http://ftp.pdc.kth.se/pub/heimdal/src/${name}.tar.gz"
    ];
    sha256 = "19gypf9vzfrs2bw231qljfl4cqc1riyg0ai0xmm1nd1wngnpphma";
  };

  ## ugly, X should be made an option
  configureFlags = [
    "--enable-hdb-openldap-module"
    "--with-capng"
    "--with-openldap=${openldap}"
    "--with-sqlite3=${sqlite}"
    "--without-x"
  ];

  # dont succeed with --libexec=$out/sbin, so
  postInstall = ''
    mv "$out/libexec/"* $out/sbin/
    rmdir $out/libexec
  '';

  buildInputs = [
    pkgconfig flex yacc readline openldap libcap_ng sqlite db ncurses
    openssl cyrus_sasl
  ];

  meta = with stdenv.lib; {
    description = "an implementation of Kerberos 5 (and some more stuff) largely written in Sweden";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
