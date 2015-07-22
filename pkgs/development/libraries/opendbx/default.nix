{ stdenv, fetchurl, readline, mysql, postgresql, sqlite }:

stdenv.mkDerivation rec {
  name = "opendbx-1.4.6";

  src = fetchurl {
    url = "http://linuxnetworks.de/opendbx/download/${name}.tar.gz";
    sha256 = "0z29h6zx5f3gghkh1a0060w6wr572ci1rl2a3480znf728wa0ii2";
  };

  preConfigure = ''
    export CPPFLAGS="-I${mysql.lib}/include/mysql"
    export LDFLAGS="-L${mysql.lib}/lib/mysql"
    configureFlagsArray=(--with-backends="mysql pgsql sqlite3")
  '';

  buildInputs = [ readline mysql.lib postgresql sqlite ];
}
