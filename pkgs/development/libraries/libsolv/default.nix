{ stdenv, fetchFromGitHub, cmake, zlib, expat, rpm, db }:

stdenv.mkDerivation rec {
  rev  = "0.6.23";
  name = "libsolv-${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "openSUSE";
    repo   = "libsolv";
    sha256 = "08ba7yx0br421lk6zf5mp0yl6nznkmc2vbka20qwm2lx5f0a25xg";
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

