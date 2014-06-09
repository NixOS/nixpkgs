{ stdenv, fetchgit, libtool, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "libmkv-0.6.5.1p2";
  
  src = fetchgit {
    url = https://github.com/saintdev/libmkv.git;
    rev = "refs/tags/0.6.5.1";
    sha256 = "1b0441x5rl5dbwrc0hq9jih111iil7ckqws3hcdj63jx2ma3s4hi";
  };

  nativeBuildInputs = [ libtool autoconf automake ];

  # TODO fix library version
  preConfigure = "sh bootstrap.sh";

  # From Handbrake
  patches = [
    ./A01-hbmv-pgs.patch
    ./A02-audio-out-sampling-freq.patch
    ./P00-mingw-large-file.patch
  ];

  meta = {
    homepage = https://github.com/saintdev/libmkv;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
  };
}
