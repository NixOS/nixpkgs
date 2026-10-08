{
  lib,
  stdenv,
  fetchurl,
  libpcap,
  pkg-config,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tcpdump";
  version = "4.99.6";

  src = fetchurl {
    url = "https://www.tcpdump.org/release/tcpdump-${finalAttrs.version}.tar.gz";
    hash = "sha256-WDmSGg9n19j6PazZzUHkTInMuGfoptshbWJijH/RSwk=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  nativeBuildInputs = [ pkg-config ];

  nativeCheckInputs = [ perl ];

  buildInputs = [ libpcap ];

  configureFlags = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "ac_cv_linux_vers=2";

  meta = {
    description = "Network sniffer";
    homepage = "https://www.tcpdump.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ globin ];
    platforms = lib.platforms.unix;
    mainProgram = "tcpdump";
  };
})
