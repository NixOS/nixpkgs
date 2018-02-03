{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "0.9.5";
  name = "liburcu-${version}";

  src = fetchurl {
    url = "http://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "19iq7985rhvbrj99hlmbyq2wjrkhssvigh5454mhaprn3c7jaj6r";
  };

  nativeBuildInputs = stdenv.lib.optional doCheck perl;

  preCheck = "patchShebangs tests/unit";
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = http://lttng.org/urcu;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };

}
