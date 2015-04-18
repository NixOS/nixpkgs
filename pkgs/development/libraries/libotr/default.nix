{ stdenv, fetchurl, libgcrypt, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libotr-4.1.0";

  src = fetchurl {
    url = "https://otr.cypherpunks.ca/${name}.tar.gz";
    sha256 = "0c6rkh58s6wqzcrpccwdik5qs91qj6dgd60a340d72gc80cqknsg";
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
