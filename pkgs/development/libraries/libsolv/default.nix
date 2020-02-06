{ stdenv, fetchFromGitHub, cmake, ninja, zlib, expat, rpm, db }:

stdenv.mkDerivation rec {
  version  = "0.7.10";
  pname = "libsolv";

  src = fetchFromGitHub {
    owner  = "openSUSE";
    repo   = "libsolv";
    rev    = version;
    sha256 = "1qih2j2vng32hk5c0v16gcr7nfq218hrync7xbn33aham8cxfrfa";
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
    homepage    = "https://github.com/openSUSE/libsolv";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

