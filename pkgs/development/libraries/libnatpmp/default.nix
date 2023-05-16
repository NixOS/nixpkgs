<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, fetchpatch
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "libnatpmp";
  version = "20230423";

  src = fetchurl {
    url = "https://miniupnp.tuxfamily.org/files/${pname}-${version}.tar.gz";
    hash = "sha256-BoTtLIQGQ351GaG9IOqDeA24cbOjpddSMRuj6Inb/HA=";
  };

  patches = [
    # install natpmp_declspec.h too, else nothing that uses this library will build
    (fetchpatch {
      url = "https://github.com/miniupnp/libnatpmp/commit/5f4a7c65837a56e62c133db33c28cd1ea71db662.patch";
      hash = "sha256-tvoGFmo5AzUgb40bIs/EzikE0ex1SFzE5peLXhktnbc=";
    })
  ];

=======
{ lib, stdenv, fetchurl, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "libnatpmp";
  version = "20150609";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "http://miniupnp.free.fr/files/download.php?file=${pname}-${version}.tar.gz";
    sha256 = "1c1n8n7mp0amsd6vkz32n8zj3vnsckv308bb7na0dg0r8969rap1";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
