{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  automake,
  libtool,
  perl,
  treecc,
  pnet,
}:

stdenv.mkDerivation {
  pname = "pnetlib";
  version = "0.8.0-unstable-2011-03-21";

  src = fetchgit {
    url = "git://git.sv.gnu.org/dotgnu-pnet/pnetlib.git";
    rev = "c3c12b8b0c65f5482d03d6a4865f7670e98baf4c";
    sha256 = "04dikki3lr3m1cacirld90rpi95656b2y2mc5rkycb7s0yfdz1nk";
  };

  nativeBuildInputs = [
    autoreconfHook
    automake
    libtool
    perl
    treecc
  ];

  buildInputs = [ pnet ];

  postPatch = ''
    rm -f configure config.guess config.sub install-sh ltmain.sh
    find . \( -name 'Makefile' -o -name 'Makefile.in' \) -delete
    perl -0pi -e 's/System\.Windows\.Forms//g' tests/Makefile.am
    perl -0pi -e 's/^TESTS_ENVIRONMENT.*$/LOG_COMPILER = \$(SHELL)\nAM_LOG_FLAGS = \$(top_builddir)\/tools\/run_test.sh \$(top_builddir)/mg' tests/Makefile.am
    substituteInPlace tools/run_test.sh.in --replace-fail en_US en_US.utf8
    perl -0pi -e 's|exec \$LN_S clrwrap "\$1"|echo "#!\@SHELL\@" >> \$1\necho exec \$CLRWRAP \$(dirname \$(dirname \$1))/lib/cscc/lib/\$(basename \$1).exe >> \$1\nchmod +x \$1|g' tools/wrapper.sh.in
  '';

  env.CFLAGS = "-O2 -g -Wno-pointer-to-int-cast";

  doCheck = false;

  meta = {
    description = "DotGNU Portable.NET class libraries";
    homepage = "http://www.gnu.org/software/dotgnu/html2.0/pnet.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
