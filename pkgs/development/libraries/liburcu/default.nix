{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "0.10.1";
  name = "liburcu-${version}";

  src = fetchurl {
    url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "01pbg67qy5hcssy2yi0ckqapzfclgdq93li2rmzw4pa3wh5j42cw";
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
