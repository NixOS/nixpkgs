{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tkrzw";
  version = "0.9.3";
  # TODO: defeat multi-output reference cycles

  src = fetchurl {
    url = "https://dbmx.net/tkrzw/pkg/tkrzw-${version}.tar.gz";
    sha256 = "1ap93fsw7vhn329kvy8g20l8p4jdygfl8r8mrgsfcpa20a29fnwl";
  };

  enableParallelBuilding = true;

  doCheck = false; # memory intensive

  meta = with lib; {
    description = "A set of implementations of DBM";
    homepage = "https://dbmx.net/tkrzw/";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
