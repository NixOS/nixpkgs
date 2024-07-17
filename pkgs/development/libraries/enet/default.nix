{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "enet";
  version = "1.3.17";

  src = fetchurl {
    url = "http://enet.bespin.org/download/${pname}-${version}.tar.gz";
    sha256 = "1p6f9mby86af6cs7pv6h48032ip9g32c05cb7d9mimam8lchz3x3";
  };

  meta = {
    homepage = "http://enet.bespin.org/";
    description = "Simple and robust network communication layer on top of UDP";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
}
