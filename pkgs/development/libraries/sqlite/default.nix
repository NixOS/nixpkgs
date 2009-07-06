{stdenv, fetchurl, readline, static ? false}:

stdenv.mkDerivation rec {
  name = "sqlite-3.6.16";

  # Note: don't use the "amalgamation" source release, since it
  # doesn't install sqlite3.pc.
  src = fetchurl {
    url = "http://www.sqlite.org/${name}.tar.gz";
    sha256 = "1kadzd5c82x3i7vd0cfqxc3r8a2smc04fhsxpl07jxjlva4khvqc";
  };

  buildInputs = [readline];

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
