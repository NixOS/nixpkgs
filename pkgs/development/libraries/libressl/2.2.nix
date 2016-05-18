{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libressl-${version}";
  version = "2.2.7";

  src = fetchurl {
    url    = "mirror://openbsd/LibreSSL/${name}.tar.gz";
    sha256 = "1kckv36dgvvjq1ap6ahxgma4hw57zp61xsp5vjvyza5vhfrnhb3y";
  };

  enableParallelBuilding = true;

  outputs = [ "dev" "out" "man" "bin" ];

  meta = with stdenv.lib; {
    description = "Free TLS/SSL implementation";
    homepage    = "http://www.libressl.org";
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice wkennington fpletz globin ];
  };
}
