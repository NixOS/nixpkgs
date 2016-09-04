{ stdenv, fetchurl, readline, mysql, postgresql, sqlite }:

let
  inherit (stdenv.lib) getDev getLib;
in
stdenv.mkDerivation rec {
  name = "opendbx-1.4.6";

  src = fetchurl {
    url = "http://linuxnetworks.de/opendbx/download/${name}.tar.gz";
    sha256 = "0z29h6zx5f3gghkh1a0060w6wr572ci1rl2a3480znf728wa0ii2";
  };

  preConfigure = ''
    export CPPFLAGS="-I${getDev mysql.client}/include/mysql"
    export LDFLAGS="-L${getLib mysql.client}/lib/mysql -L${getLib postgresql}/lib"
    configureFlagsArray=(--with-backends="mysql pgsql sqlite3")
  '';

  buildInputs = [ readline mysql.client postgresql sqlite ];
}
