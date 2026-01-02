{
  stdenv,
  fetchurl,
  lib,
  libpcap,
}:
stdenv.mkDerivation (final: {
  name = "tcptrace";
  version = "6.6.7";

  srcs = [
    (fetchurl {
      # Home page was down on 2024-02-01, so use Debian mirror as fallback.
      urls = [
        "http://www.tcptrace.org/download/tcptrace-${final.version}.tar.gz"
        "mirror://debian/pool/main/t/tcptrace/tcptrace_${final.version}.orig.tar.gz"
      ];
      hash = "sha256-YzgKQFGTPKCJeUdqnfxvlZMIvJ9g1FJVIC44jrVpEL0=";
    })
    (fetchurl {
      url = "mirror://debian/pool/main/t/tcptrace/tcptrace_6.6.7-6.debian.tar.xz";
      hash = "sha256-8rkwzdXcDOc3kACvrlyTQsnSw6AJgy6xA0YrECu63gY=";
    })
  ];
  sourceRoot = "tcptrace-${final.version}";

  outputs = [
    "out"
    "man"
  ];

  setOutputFlags = false;

  patches = [ ./fix-owners.patch ];
  prePatch = ''
    patches_deb=(../debian/patches/bug*)
    patches+=" ''${patches_deb[*]}"
  '';

  buildInputs = [ libpcap ];
  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "man"}/share/man"
  ];

  meta = {
    description = "Tool for analysis of TCP dump files";
    homepage = "http://www.tcptrace.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.gmacon ];
    mainProgram = "tcptrace";
    platforms = lib.platforms.unix;
  };
})
