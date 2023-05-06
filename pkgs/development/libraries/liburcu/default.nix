{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "0.14.0";
  pname = "liburcu";

  src = fetchurl {
    url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "sha256-ykO/Jh1NOSz/IN+uRAg2YDvwCfziT9ybJpfYN6IjnU8=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeCheckInputs = [ perl ];

  preCheck = "patchShebangs tests/unit";
  doCheck = true;

  meta = with lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = "https://lttng.org/urcu";
    changelog = "https://github.com/urcu/userspace-rcu/raw/v${version}/ChangeLog";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };

}
