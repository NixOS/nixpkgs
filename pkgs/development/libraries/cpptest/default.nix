{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cpptest-1.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/cpptest/cpptest/${name}/${name}.tar.gz";
    sha256 = "09v070a9dv6zq6hgj4v67i31zsis3s96psrnhlq9g4vhdcaxykwy";
  };

  meta = with stdenv.lib; {
    homepage = http://cpptest.sourceforge.net/;
    description = "Simple C++ unit testing framework";
    maintainers = with maintainers; [ bosu ];
    license = stdenv.lib.licenses.lgpl3;
  };
}
