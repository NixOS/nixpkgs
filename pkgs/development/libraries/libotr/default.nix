{ stdenv, fetchurl, libgcrypt, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libotr-4.0.0";

  src = fetchurl {
    url = "https://otr.cypherpunks.ca/${name}.tar.gz";
    sha256 = "1d4k0b7v4d3scwm858cmqr9c6xgd6ppla1vk4x2yg64q82a1k49z";
  };

  buildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libgcrypt ];

  meta = with stdenv.lib; {
    homepage = "http://www.cypherpunks.ca/otr/";
    repositories.git = git://git.code.sf.net/p/otr/libotr;
    license = licenses.lgpl21;
    description = "Library for Off-The-Record Messaging";
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.unix;
  };
}
