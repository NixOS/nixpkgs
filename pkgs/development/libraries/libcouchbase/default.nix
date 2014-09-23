{ stdenv, fetchgit
, autoconf, automake, libtool, pkgconfig, perl, git
, libevent, openssl
}:

stdenv.mkDerivation {
  name = "libcouchbase-2.4.1";

  src = fetchgit {
    url = "https://github.com/couchbase/libcouchbase.git";
    rev = "bd3a20f9e18a69dca199134956fd4ad3e1b80ca8";
    sha256 = "1jv9y0qa75s5sq86qlbd42dawfawj20dnyj50kjbbld7rvlfki3b";
    leaveDotGit = true;
  };

  preConfigure = ''
    patchShebangs ./config/
    ./config/autorun.sh
  '';

  configureFlags = "--disable-couchbasemock";

  buildInputs = [
    autoconf automake libtool pkgconfig perl git
    libevent openssl
  ];

  meta = {
    description = "This is the C client library for Couchbase It communicates with the cluster and speaks the relevant protocols necessary to connect to the cluster and execute data operations.";
    homepage = "https://github.com/couchbase/libcouchbase";
    license = stdenv.lib.licenses.asl20;
  };
}
