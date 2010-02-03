{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sqlite-3.6.22";

  src = fetchurl {
    url = "http://www.sqlite.org/sqlite-amalgamation-3.6.22.tar.gz";
    sha256 = "1k5qyl0v2y4fpkh7vvxvb0irpnl71g0ffhfc3ksm40mrhcdq9qk8";
  };

  configureFlags = "--enable-threadsafe";

  NIX_CFLAGS_COMPILE = "-DSQLITE_ENABLE_COLUMN_METADATA=1";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
