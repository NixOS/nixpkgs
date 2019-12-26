{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "enet-1.3.14";

  src = fetchurl {
    url = "http://enet.bespin.org/download/${name}.tar.gz";
    sha256 = "0w780zc6cy8yq4cskpphx0f91lzh51vh9lwyc5ll8hhamdxgbxlq";
  };

  meta = {
    homepage = http://enet.bespin.org/;
    description = "Simple and robust network communication layer on top of UDP";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
