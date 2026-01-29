{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  ppp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xl2tpd";
  version = "1.3.19";

  src = fetchFromGitHub {
    owner = "xelerance";
    repo = "xl2tpd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Oyy64b5xrKOYSkiCtWksh0vKGDXHsmUNlNgVTRXftOw=";
  };

  buildInputs = [ libpcap ];

  postPatch = ''
    substituteInPlace l2tp.h --replace /usr/sbin/pppd ${ppp}/sbin/pppd
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types -std=gnu17";

  meta = {
    homepage = finalAttrs.src.meta.homepage;
    description = "Layer 2 Tunnelling Protocol Daemon (RFC 2661)";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
