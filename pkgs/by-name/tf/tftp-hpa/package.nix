{
  lib,
  stdenv,
  fetchgit,
  autoconf,
  automake,
}:

stdenv.mkDerivation {
  pname = "tftp-hpa";
  version = "5.2-untagged-2024-06-10";
  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/network/tftp/tftp-hpa.git";
    hash = "sha256-lTMldYO/cZdLj0UjOPPBHfYf2GBG0O+5lhP9ikqn3tY=";
    rev = "2c86ff58dcc003107b47f2d35aa0fdc4a3fd95e1";
  };

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: main.o:/build/tftp-hpa-5.2/tftp/main.c:98: multiple definition of
  #     `toplevel'; tftp.o:/build/tftp-hpa-5.2/tftp/tftp.c:51: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preConfigure = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoconf
    automake
  ];

  meta = with lib; {
    description = "TFTP tools - a lot of fixes on top of BSD TFTP";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.bsd3;
    homepage = "https://www.kernel.org/pub/software/network/tftp/";
  };

  passthru = {
    updateInfo = {
      downloadPage = "https://www.kernel.org/pub/software/network/tftp/";
    };
  };
}
