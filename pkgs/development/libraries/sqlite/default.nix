{stdenv, fetchurl, readline, static ? false}:

stdenv.mkDerivation rec {
  name = "sqlite-3.6.12";

  # Note: don't use the "amalgamation" source release, since it
  # doesn't install sqlite3.pc.
  src = fetchurl {
    url = "http://www.sqlite.org/${name}.tar.gz";
    sha256 = "00cj6bda0kqqn6m3g8k4n4w1rnj76mgk47hf03j0d3w0j0g3rhln";
  };

  buildInputs = [readline];

  configureFlags = ''
    ${if static then "--disable-shared --enable-static" else "--disable-static"}
    --with-readline-inc=-I${readline}/include
  '';

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
