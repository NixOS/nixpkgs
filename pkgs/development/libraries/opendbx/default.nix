{ lib, stdenv, fetchurl, readline, libmysqlclient, postgresql, sqlite }:

let inherit (lib) getDev; in

stdenv.mkDerivation rec {
  pname = "opendbx";
  version = "1.4.6";

  src = fetchurl {
    url = "https://linuxnetworks.de/opendbx/download/opendbx-${version}.tar.gz";
    sha256 = "0z29h6zx5f3gghkh1a0060w6wr572ci1rl2a3480znf728wa0ii2";
  };

  preConfigure = ''
    export CPPFLAGS="-I${getDev libmysqlclient}/include/mysql"
    export LDFLAGS="-L${libmysqlclient}/lib/mysql -L${postgresql}/lib"
    configureFlagsArray=(--with-backends="mysql pgsql sqlite3")
  '';

  buildInputs = [ readline libmysqlclient postgresql sqlite ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Extremely lightweight but extensible database access library written in C";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
