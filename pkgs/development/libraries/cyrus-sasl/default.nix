{ stdenv, fetchurl, openssl, db4, gettext, pam }:

stdenv.mkDerivation rec {
  name = "cyrus-sasl-2.1.26";

  src = fetchurl {
    url = "ftp://ftp.cyrusimap.org/cyrus-sasl/${name}.tar.gz";
    sha256 = "1hvvbcsg21nlncbgs0cgn3iwlnb3vannzwsp6rwvnn9ba4v53g4g";
  };

  buildInputs = [ openssl db4 gettext ] ++ stdenv.lib.optional stdenv.isLinux pam;

  # Set this variable at build-time to make sure $out can be evaluated.
  preConfigure = ''
    configureFlagsArray=( --with-plugindir=$out/lib/sasl2
                          --with-configdir=$out/lib/sasl2
			  --with-saslauthd=/run/saslauthd
			  --enable-login
			)
  '';

  meta = {
    homepage = "http://cyrusimap.web.cmu.edu/";
    description = "library for adding authentication support to connection-based protocols";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
