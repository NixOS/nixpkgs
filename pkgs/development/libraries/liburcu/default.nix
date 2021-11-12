{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "0.13.0";
  pname = "liburcu";

  src = fetchurl {
    url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "sha256-y7INvhqJLCpNiJi6xDFhduWFOSaT1Jh2bMu8aM8guiA=";
  };

  checkInputs = [ perl ];

  preCheck = "patchShebangs tests/unit";
  doCheck = true;

  meta = with lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = "https://lttng.org/urcu";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };

}
