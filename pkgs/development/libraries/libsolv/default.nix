{ stdenv, fetchFromGitHub, cmake, ninja, zlib, expat, rpm, db }:

stdenv.mkDerivation rec {
  rev  = "0.6.34";
  name = "libsolv-${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "openSUSE";
    repo   = "libsolv";
    sha256 = "1knr48dilg8kscbmpjvd7m2krvgcdq0f9vpbqcgmxxa969mzrcy7";
  };

  cmakeFlags = {
    ENABLE_COMPLEX_DEPS = true;
    ENABLE_RPMMD = true;
    ENABLE_RPMDB = true;
    ENABLE_PUBKEY = true;
    ENABLE_RPMDB_BYRPMHEADER = true;
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ zlib expat rpm db ];

  meta = with stdenv.lib; {
    description = "A free package dependency solver";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

