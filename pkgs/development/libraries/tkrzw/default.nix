{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tkrzw";
  version = "1.0.21";
  # TODO: defeat multi-output reference cycles

  src = fetchurl {
    url = "https://dbmx.net/tkrzw/pkg/tkrzw-${version}.tar.gz";
    hash = "sha256-1g3sIRXxYtD8XGVNpbn4HLTCi+xl2yfJklbUouMQcHs=";
  };

  enableParallelBuilding = true;

  doCheck = false; # memory intensive

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A set of implementations of DBM";
    homepage = "https://dbmx.net/tkrzw/";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
