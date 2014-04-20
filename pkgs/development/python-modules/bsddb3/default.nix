{stdenv, fetchurl, python, db}:

stdenv.mkDerivation rec {
  name = "bsddb3-6.0.1";
  src = fetchurl {
    url = "https://pypi.python.org/packages/source/b/bsddb3/${name}.tar.gz";
    md5 = "2b22ab1b4d896961c30e4106660e9139";
  };
  buildInputs = [python];
  buildPhase = "true";
  installPhase = "python ./setup.py install --prefix=$out --berkeley-db=${db}";
}
