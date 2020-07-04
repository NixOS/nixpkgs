{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "0.12.1";
  pname = "liburcu";

  src = fetchurl {
    url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "03nd1gy2c3fdb6xwdrd5lr1jcjxbzffqh3z91mzbjhjn6k8fmymv";
  };

  checkInputs = [ perl ];

  preCheck = "patchShebangs tests/unit";
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = "https://lttng.org/urcu";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };

}
