{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "libipfix";
  version = "110209";
  src = fetchurl {
    url = "mirror://sourceforge/libipfix/files/libipfix/libipfix_110209.tgz";
    sha256 = "0h7v0sxjjdc41hl5vq2x0yhyn04bczl11bqm97825mivrvfymhn6";
  };

  # Workaround build failure on -fno-common toolchains:
  #   ld: ../libmisc/libmisc.a(mlog.o):/build/libipfix_110209/libmisc/misc.h:111: multiple definition of
  #     `ht_globals'; collector.o:/build/libipfix_110209/collector/../libmisc/misc.h:111: first defined here
  # TODO: drop the workaround when fix ix released:
  #   https://sourceforge.net/p/libipfix/code/ci/a501612c6b8ac6f2df16b366f7a92211382bae6b/
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = with lib; {
    homepage = "https://libipfix.sourceforge.net/";
    description = "The libipfix C-library implements the IPFIX protocol defined by the IP Flow Information Export working group of the IETF";
    mainProgram = "ipfix_collector";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lewo ];
  };
}
