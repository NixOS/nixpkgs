{stdenv, fetchurl, python}:

stdenv.mkDerivation {
  name = "ZopeInterface-3.1.0c1";
  src = fetchurl {
    url = http://www.zope.org/Products/ZopeInterface/3.1.0c1/ZopeInterface-3.1.0c1.tgz;
    md5 = "f34cb95f2fbdbe3f1850c95cefddbd2c";
  };
  buildInputs = [python];
  buildPhase = "true";
  installPhase = "python ./setup.py install --prefix=$out";
}
