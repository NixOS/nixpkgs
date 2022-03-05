{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libnatpmp";
  version = "20150609";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "http://miniupnp.free.fr/files/download.php?file=${pname}-${version}.tar.gz";
    sha256 = "1c1n8n7mp0amsd6vkz32n8zj3vnsckv308bb7na0dg0r8969rap1";
  };

  makeFlags = [
    "INSTALLPREFIX=$(out)"
    "CC:=$(CC)"
  ];

  postFixup = ''
    chmod +x $out/lib/*
  '';

  meta = with lib; {
    homepage = "http://miniupnp.free.fr/libnatpmp.html";
    description = "NAT-PMP client";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}
