{stdenv, fetchurl, python, db}:

stdenv.mkDerivation rec {
  name = "bsddb3-6.1.0";
  src = fetchurl {
    url = "https://pypi.python.org/packages/source/b/bsddb3/${name}.tar.gz";
    sha256 = "05gx3rfgq1qrgdmpd6hri6y5l97bh1wczvb6x853jchwi7in6cdi";
  };
  buildInputs = [python];
  buildPhase = "true";
  installPhase = "python ./setup.py install --prefix=$out --berkeley-db=${db}";
}
