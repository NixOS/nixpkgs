{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tnat64";
  version = "0.06";

  src = fetchFromGitHub {
    owner = "andrewshadura";
    repo = "tnat64";
    rev = "tnat64-${finalAttrs.version}";
    hash = "sha256-RopoiCvTvuAVK7OX4MZ4oRocz0+JXovIdIavka8LMqQ=";
  };

  configureFlags = [ "--libdir=$(out)/lib" ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "IPv4 to IPv6 interceptor";
    homepage = "https://github.com/andrewshadura/tnat64";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      TNAT64 is an interceptor which redirects outgoing TCPv4 connections
      through NAT64, thus enabling an application running on an IPv6-only host
      to communicate with the IPv4 world, even if that application does not
      support IPv6 at all.
    '';
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    maintainers = [ lib.maintainers.rnhmjoj ];
  };

})
