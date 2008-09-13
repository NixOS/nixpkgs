{stdenv, fetchurl, libgcrypt}:

stdenv.mkDerivation {
  name = "libotr-3.2.0";
  src = fetchurl {
    url = http://www.cypherpunks.ca/otr/libotr-3.2.0.tar.gz;
    sha256 = "14v6idnqpp2vhgir9bzp1ay2gmhqsb8iavrkwmallakfwch9sfyq";
  };

  propagatedBuildInputs = [libgcrypt];
}
