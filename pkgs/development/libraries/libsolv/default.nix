{ stdenv, fetchFromGitHub, cmake, ninja, zlib, expat, rpm, db }:

stdenv.mkDerivation rec {
  version  = "0.7.1";
  name = "libsolv-${version}";

  src = fetchFromGitHub {
    owner  = "openSUSE";
    repo   = "libsolv";
    rev    = version;
    sha256 = "0ssiadh10d28gzmq9vpgvvwmkw5ccb5iglafzsx3pf33z1zp5a3b";
  };

  cmakeFlags = [
    "-DENABLE_COMPLEX_DEPS=true"
    "-DENABLE_RPMMD=true"
    "-DENABLE_RPMDB=true"
    "-DENABLE_PUBKEY=true"
    "-DENABLE_RPMDB_BYRPMHEADER=true"
  ];

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ zlib expat rpm db ];

  meta = with stdenv.lib; {
    description = "A free package dependency solver";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

