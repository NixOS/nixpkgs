{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "popt";
  version = "1.19";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-${version}.tar.gz";
    sha256 = "sha256-wlpIOPyOTByKrLi9Yg7bMISj1jv4mH/a08onWMYyQPk=";
  };

  patches = lib.optionals stdenv.isCygwin [
    ./1.16-cygwin.patch
    ./1.16-vpath.patch
  ];

  doCheck = false; # fails

  meta = with lib; {
    homepage = "https://github.com/rpm-software-management/popt";
    description = "Command line option parsing library";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
