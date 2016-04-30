{ stdenv, fetchFromGitHub, cmake, zlib, expat, rpm, db }:

stdenv.mkDerivation rec {
  rev  = "0.6.20";
  name = "libsolv-${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "openSUSE";
    repo   = "libsolv";
    sha256 = "1gammarbnjbbkw2vlgcj9ynp1kgi5nns6xcl6ab8b5i4zgq91v2p";
  };

  cmakeFlags = "-DENABLE_RPMMD=true -DENABLE_RPMDB=true -DENABLE_PUBKEY=true -DENABLE_RPMDB_BYRPMHEADER=true";

  buildInputs = [ cmake zlib expat rpm db ];

  meta = with stdenv.lib; {
    description = "A free package dependency solver";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

