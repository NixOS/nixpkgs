{ stdenv, buildPythonPackage, fetchurl
, sqlite, isPyPy }:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.7.6.2-r1";
  name = "${pname}-${version}";

  disabled = isPyPy;

  src = fetchurl {
    url = "http://apsw.googlecode.com/files/${name}.zip";
    sha256 = "cb121b2bce052609570a2f6def914c0aa526ede07b7096dddb78624d77f013eb";
  };

  buildInputs = [ sqlite ];

  # python: double free or corruption (fasttop): 0x0000000002fd4660 ***
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = http://code.google.com/p/apsw/;
  };
}
