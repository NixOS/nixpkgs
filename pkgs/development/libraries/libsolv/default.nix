{ stdenv, fetchFromGitHub, cmake, ninja, zlib, expat, rpm, db }:

stdenv.mkDerivation rec {
  version  = "0.7.14";
  pname = "libsolv";

  src = fetchFromGitHub {
    owner  = "openSUSE";
    repo   = "libsolv";
    rev    = version;
    sha256 = "10klbgknl2njbjl4k0l50ii7afwqrl1691ar4ry3snmc8chb1z7g";
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

