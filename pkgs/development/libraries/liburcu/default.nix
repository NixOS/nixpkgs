{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "0.11.0";
  name = "liburcu-${version}";

  src = fetchurl {
    url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "1rxk5vbkbmqlsnjnvkjz0pkx2076mqnq6jzblpmz8rk29x66kx8s";
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
