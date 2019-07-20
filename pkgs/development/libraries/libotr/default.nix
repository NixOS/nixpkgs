{ stdenv, fetchurl, libgcrypt, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libotr-4.1.1";

  src = fetchurl {
    url = "https://otr.cypherpunks.ca/${name}.tar.gz";
    sha256 = "1x8rliydhbibmzwdbyr7pd7n87m2jmxnqkpvaalnf4154hj1hfwb";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];
  propagatedBuildInputs = [ libgcrypt ];

  meta = with stdenv.lib; {
    homepage = http://www.cypherpunks.ca/otr/;
    repositories.git = git://git.code.sf.net/p/otr/libotr;
    license = licenses.lgpl21;
    description = "Library for Off-The-Record Messaging";
    platforms = platforms.unix;
  };
}
