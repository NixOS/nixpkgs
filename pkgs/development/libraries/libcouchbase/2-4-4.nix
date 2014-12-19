{ stdenv, fetchgit, autoconf, automake, libtool,
pkgconfig, perl, git, libevent, openssl}:

stdenv.mkDerivation {
  name = "libcouchbase-2.4.4";
  src = fetchgit {
    url = "https://github.com/couchbase/libcouchbase.git";
    rev = "4410eebcd813844b6cd6f9c7eeb4ab3dfa2ab8ac";
    sha256 = "02lzv5l6fvnqr2l9bqfha0pzkzlzjfddn3w5zcbjz36kw4p2p4h9";
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