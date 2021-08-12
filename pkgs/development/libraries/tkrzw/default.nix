{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tkrzw";
  version = "0.9.51";
  # TODO: defeat multi-output reference cycles

  src = fetchurl {
    url = "https://dbmx.net/tkrzw/pkg/tkrzw-${version}.tar.gz";
    hash = "sha256-UqF2cJ/r8OksAKyHw6B9UiBFIXgKeDmD2ZyJ+iPkY2w=";
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
