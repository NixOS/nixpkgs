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
    ${if static then "--disable-shared --enable-static" else ""}
    --with-readline-inc=-I${readline}/include
  '';

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
