{stdenv, fetchurl, python}:

stdenv.mkDerivation {
  name = "ZopeInterface-3.3.0";
  src = fetchurl {
    url = http://www.zope.org/Products/ZopeInterface/3.3.0/zope.interface-3.3.0.tar.gz;
    sha256 = "0xahg9cmagn4j3dbifvgzbjliw2jdrbf27fhqwkdp8j80xpyyjf0";
  };
  buildInputs = [python];
  buildPhase = "true";
  installPhase = "python ./setup.py install --prefix=$out";
}
