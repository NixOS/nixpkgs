{stdenv, fetchurl, readline}:

stdenv.mkDerivation {
  name = "sqlite-3.5.9";

  # Note: don't use the "amalgamation" source release, since it
  # doesn't install sqlite3.pc.
  src = fetchurl {
    url = http://www.sqlite.org/sqlite-3.5.9.tar.gz;
    sha256 = "0731zj0fnivhfc74wc3yh0p9gn7fpjgy3g79haarciqkdf8k3lvx";
  };

  buildInputs = [readline];

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
