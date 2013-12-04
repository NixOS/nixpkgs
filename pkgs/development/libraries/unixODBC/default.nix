{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "unixODBC-2.3.2";
  src = fetchurl {
    url = "ftp://ftp.unixodbc.org/pub/unixODBC/${name}.tar.gz";
    sha256 = "16jw5fq7wgfky6ak1h2j2pqx99jivsdl4q8aq6immpr55xs5jd4w";
  };
  configureFlags = "--disable-gui --sysconfdir=/etc";
}
