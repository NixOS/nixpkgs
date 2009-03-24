{stdenv, fetchurl, readline, static ? false}:

stdenv.mkDerivation rec {
  name = "sqlite-3.6.10";

  # Note: don't use the "amalgamation" source release, since it
  # doesn't install sqlite3.pc.
  src = fetchurl {
    url = "http://www.sqlite.org/${name}.tar.gz";
    sha256 = "00dabyjg0530ng52b8lq6hwb6h181wl27ix5l7ayib0am8sdnmr1";
  };

  buildInputs = [readline];

  configureFlags = ''
    ${if static then "--disable-shared --enable-static" else "--disable-static"}
    --with-readline-inc=-I${readline}/include
  '';

  postInstall = ''
    gcc -L$out/lib -I$out/include tool/genfkey.c -lsqlite3 -o $out/bin/genfkey
  '';

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
