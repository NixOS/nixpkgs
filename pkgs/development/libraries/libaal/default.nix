{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libaal-1.0.5";

  src = fetchurl {
    url = http://chichkin_i.zelnet.ru/namesys/libaal-1.0.5.tar.gz;
    sha256 = "109f464hxwms90mpczc7h7lmrdlcmlglabkzh86h25xrlxxdn6pz";
  };

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  meta = {
    homepage = http://www.namesys.com/;
    description = "Support library for Reiser4";
  };
}
