{ stdenv, fetchFromGitHub, cmake, zlib, expat, rpm, db }:

stdenv.mkDerivation rec {
  rev  = "0.6.32";
  name = "libsolv-${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "openSUSE";
    repo   = "libsolv";
    sha256 = "0gqvnnc1s5n0yj82ia6w2wjhhn8hpl6wm4lki2kzvjqjgla45fnq";
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

