{ stdenv, fetchurl, readline, mysql, postgresql, sqlite }:

stdenv.mkDerivation rec {
  name = "opendbx-1.4.6";

  src = fetchurl {
    url = "https://linuxnetworks.de/opendbx/download/${name}.tar.gz";
    sha256 = "0z29h6zx5f3gghkh1a0060w6wr572ci1rl2a3480znf728wa0ii2";
  };

  preConfigure = ''
    export CPPFLAGS="-I${mysql.connector-c}/include/mysql"
    export LDFLAGS="-L${mysql.connector-c}/lib/mysql -L${postgresql}/lib"
    configureFlagsArray=(--with-backends="mysql pgsql sqlite3")
  '';

  buildInputs = [ readline mysql.connector-c postgresql sqlite ];

  meta = with stdenv.lib; {
    description = "Extremely lightweight but extensible database access library written in C";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
