{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coredumper-1.1";
  src = fetchurl {
    url = http://google-coredumper.googlecode.com/files/coredumper-1.1.tar.gz;
    sha256 = "1phl1zg2n17rp595dyzz9iw01gfdpsdh0l6wy2hfb5shi71h63rx";
  };

  # Doesn't build:
  #
  # src/elfcore.c: In function 'CreatePipeline':
  # src/elfcore.c:1424:26: error: 'CLONE_VM' undeclared (first use in this function)
  #                           CLONE_VM|CLONE_UNTRACED|SIGCHLD, &args, 0, 0, 0);
  #                           ^
  # src/elfcore.c:1424:26: note: each undeclared identifier is reported only once for each function it appears in
  meta.broken = true;
}
