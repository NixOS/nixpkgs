{ stdenv, fetchFromGitHub, cmake, ninja, zlib, expat, rpm, db }:

stdenv.mkDerivation rec {
  version  = "0.7.2";
  name = "libsolv-${version}";

  src = fetchFromGitHub {
    owner  = "openSUSE";
    repo   = "libsolv";
    rev    = version;
    sha256 = "03zwf7zqz7ghd0bgs0wvlhnsd828z69kl28q2n6m4z57ai8zzqng";
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

