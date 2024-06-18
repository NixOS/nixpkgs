{ lib, stdenv, fetchurl, zeromq }:

stdenv.mkDerivation rec {
  version = "4.2.1";
  pname = "czmq";

  src = fetchurl {
    url = "https://github.com/zeromq/czmq/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-XXIKIEwqWGRdb3ZDrxXVY6cS2tmMnTLB7ZEzd9qmrDk=";
  };

  # Needs to be propagated for the .pc file to work
  propagatedBuildInputs = [ zeromq ];

  meta = with lib; {
    homepage = "http://czmq.zeromq.org/";
    description = "High-level C Binding for ZeroMQ";
    mainProgram = "zmakecert";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
