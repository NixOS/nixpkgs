{ stdenv, fetchgit, libtool, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "libmkv-${version}";
  version = "0.6.5.1";

  src = fetchgit {
    url = https://github.com/saintdev/libmkv.git;
    rev = "refs/tags/${version}";
    sha256 = "0pr9q7yprndl8d15ir7i7cznvmf1yqpvnsyivv763n6wryssq6dl";
  };

  nativeBuildInputs = [ libtool autoconf automake ];

  preConfigure = "sh bootstrap.sh";

  meta = {
    homepage = https://github.com/saintdev/libmkv;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
    platforms = stdenv.lib.platforms.unix;
  };
}
