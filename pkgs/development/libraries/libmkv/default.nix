{ stdenv, fetchgit, libtool, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "libmkv-0.6.5.1p2";
  
  src = fetchgit {
    url = https://github.com/saintdev/libmkv.git;
    rev = "refs/tags/0.6.5.1";
    sha256 = "0pr9q7yprndl8d15ir7i7cznvmf1yqpvnsyivv763n6wryssq6dl";
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
    platforms = stdenv.lib.platforms.unix;
  };
}
