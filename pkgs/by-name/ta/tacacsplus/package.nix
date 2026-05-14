{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  perl,
  libnsl,
  withLibWrap ? true,
  tcp_wrappers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tacacsplus";
  version = "4.0.4.31";

  src = fetchurl {
    url = "ftp://ftp.shrubbery.net/pub/tac_plus/tacacs-F${finalAttrs.version}.tar.gz";
    hash = "sha256-MKad/Ax1vbz7GPV23l79cq6qBwnDGMBPFTcjn0UeyA8=";
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

  meta = {
    description = "Protocol for authentication, authorization and accounting (AAA) services for routers and network devices";
    homepage = "http://www.shrubbery.net/tac_plus/";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    platforms = with lib.platforms; linux;
  };
})
