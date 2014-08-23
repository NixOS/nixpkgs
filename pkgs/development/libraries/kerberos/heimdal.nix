{ stdenv, fetchurl, openldap, readline, db, openssl, cyrus_sasl, sqlite} :

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
    "--with-openldap=${openldap}"
    "--with-sqlite3=${sqlite}"
    "--without-x"
  ];
  # dont succeed with --libexec=$out/sbin, so
  postInstall = ''
    mv "$out/libexec/"* $out/sbin/
    rmdir $out/libexec
  '';

  propagatedBuildInputs = [ readline db openssl openldap cyrus_sasl sqlite];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
