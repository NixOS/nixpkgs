{ lib, stdenv, fetchurl, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "libnatpmp";
  version = "20230423";

  src = fetchurl {
    url = "https://miniupnp.tuxfamily.org/files/${pname}-${version}.tar.gz";
    hash = "sha256-BoTtLIQGQ351GaG9IOqDeA24cbOjpddSMRuj6Inb/HA=";
  };

  makeFlags = [
    "INSTALLPREFIX=$(out)"
    "CC:=$(CC)"
  ];

  nativeBuildInputs = lib.optional stdenv.isDarwin fixDarwinDylibNames;

  postFixup = ''
    chmod +x $out/lib/*
  '';

  meta = with lib; {
    description = "NAT-PMP client";
    homepage = "http://miniupnp.free.fr/libnatpmp.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orivej ];
    mainProgram = "natpmpc";
    platforms = platforms.all;
  };
}
