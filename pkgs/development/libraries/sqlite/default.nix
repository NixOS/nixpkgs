{stdenv, fetchurl, readline, tcl, static ? false}:

stdenv.mkDerivation rec {
  name = "sqlite-3.6.19";

  # Note: don't use the "amalgamation" source release, since it
  # doesn't install sqlite3.pc.
  src = fetchurl {
    url = "http://www.sqlite.org/${name}.tar.gz";
    sha256 = "7d8649c44fb97b874aa59144faaeb2356ec1fc6a8a7baa1d16e9ff5f1e097003";
  };

  buildInputs = [readline tcl];

  configureFlags = ''
    --enable-load-extension
    ${if static then "--disable-shared --enable-static" else ""}
    --disable-amalgamation
    --enable-threadsafe
    --disable-cross-thread-connections
    --disable-tcl
    --disable-tempstore
    --with-readline-inc=-I${readline}/include
  '';

  NIX_CFLAGS_COMPILE = "-DSQLITE_ENABLE_COLUMN_METADATA=1";
  NIX_CFLAGS_LINK = "-ldl"; # needed for --enable-load-extension

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
