{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "0.11.1";
  pname = "liburcu";

  src = fetchurl {
    url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "0l1kxgzch4m8fxiz2hc8fwg56hrvzzspp7n0svnl7i7iycdrgfcj";
  };

  checkInputs = [ perl ];

  preCheck = "patchShebangs tests/unit";
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = https://lttng.org/urcu;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };

}
