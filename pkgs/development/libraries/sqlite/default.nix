{stdenv, fetchurl, readline}:

stdenv.mkDerivation {
  name = "sqlite-3.6.3";

  # Note: don't use the "amalgamation" source release, since it
  # doesn't install sqlite3.pc.
  src = fetchurl {
    url = http://www.sqlite.org/sqlite-3.6.3.tar.gz;
    sha256 = "0kd9dpbrjp05159qsqwrm00h6a2cqjxqwpi33b6i5q8mr1bzkz1i";
  };

  buildInputs = [readline];

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
