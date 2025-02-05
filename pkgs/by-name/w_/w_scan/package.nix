{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "w_scan";
  version = "20170107";

  src = fetchurl {
    url = "http://wirbel.htpc-forum.de/w_scan/${pname}-${version}.tar.bz2";
    sha256 = "1zkgnj2sfvckix360wwk1v5s43g69snm45m0drnzyv7hgf5g7q1q";
  };

  # Workaround build failure on -fno-common toolchains:
  #   ld: char-coding.o:/build/w_scan-20170107/si_types.h:117: multiple definition of
  #     `service_t'; countries.o:/build/w_scan-20170107/si_types.h:117: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = {
    description = "Small CLI utility to scan DVB and ATSC transmissions";
    homepage = "http://wirbel.htpc-forum.de/w_scan/index_en.html";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
    license = lib.licenses.gpl2;
    mainProgram = "w_scan";
  };
}
