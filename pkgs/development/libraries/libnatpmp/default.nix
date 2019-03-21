{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libnatpmp-${version}";
  version = "20150609";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "1c1n8n7mp0amsd6vkz32n8zj3vnsckv308bb7na0dg0r8969rap1";
  };

  makeFlags = [ "INSTALLPREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://miniupnp.free.fr/libnatpmp.html;
    description = "NAT-PMP client";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
