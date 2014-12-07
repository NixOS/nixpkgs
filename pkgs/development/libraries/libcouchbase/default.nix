{ stdenv, fetchgit, autoconf, automake, libtool,
pkgconfig, perl, git, libevent, openssl}:

stdenv.mkDerivation {
  name = "libcouchbase-2.4.1";
  src = fetchgit {
    url = "https://github.com/couchbase/libcouchbase.git";
    rev = "bd3a20f9e18a69dca199134956fd4ad3e1b80ca8";
    sha256 = "1a1hg9zvnl1icw59xib5wnk3s120isf8c5awm8id6icvhxjv40hd";
    leaveDotGit = true;
  };

  preConfigure = ''
    patchShebangs ./config/
    ./config/autorun.sh
  '';

  configureFlags = "--disable-couchbasemock";

  buildInputs = [ autoconf automake libtool pkgconfig perl git libevent openssl];

  meta = {
    description = "C client library for Couchbase.";
    homepage = "https://github.com/couchbase/libcouchbase";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;

  };
}