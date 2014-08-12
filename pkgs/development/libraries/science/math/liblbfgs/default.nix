{ stdenv, fetchurl }:
stdenv.mkDerivation {
  name = "liblbfgs-1.10";

  configureFlags = "--enable-sse2";
  src = fetchurl {
    url = https://github.com/downloads/chokkan/liblbfgs/liblbfgs-1.10.tar.gz;
    sha256 = "1kv8d289rbz38wrpswx5dkhr2yh4fg4h6sszkp3fawxm09sann21";
  };

  meta = {
    description = "Library of Limited-memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS)";
    homepage = http://www.chokkan.org/software/liblbfgs/;
    license = stdenv.lib.licenses.mit;
  };
}
