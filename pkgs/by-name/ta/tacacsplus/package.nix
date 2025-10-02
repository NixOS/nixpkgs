{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  perl,
  libnsl,
  # --with-libwrap=yes is currently broken, TODO unbreak
  withLibWrap ? false,
  tcp_wrappers,
}:

stdenv.mkDerivation rec {
  pname = "tacacsplus";
  version = "4.0.4.28";

  src = fetchurl {
    url = "ftp://ftp.shrubbery.net/pub/tac_plus/tacacs-F${version}.tar.gz";
    hash = "sha256-FH8tyY0m0vk/Crp2yYjO0Zb/4cAB3C6R94ihosdHIZ4=";
  };

  nativeBuildInputs = [
    flex
    bison
  ];
  buildInputs = [
    perl
    libnsl
  ]
  ++ lib.optionals withLibWrap [
    tcp_wrappers
  ];

  configureFlags = lib.optionals (!withLibWrap) [
    "--with-libwrap=no"
  ];

  meta = with lib; {
    description = "Protocol for authentication, authorization and accounting (AAA) services for routers and network devices";
    homepage = "http://www.shrubbery.net/tac_plus/";
    license = licenses.free;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = with platforms; linux;
  };
}
