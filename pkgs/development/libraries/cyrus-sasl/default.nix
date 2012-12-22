{ stdenv, fetchurl, openssl, db4, gettext, pam }:

stdenv.mkDerivation rec {
  name = "cyrus-sasl-2.1.25";

  src = fetchurl {
    url = "ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/${name}.tar.gz";
    sha256 = "418c16e6240a4f9b637cbe3d62937b9675627bad27c622191d47de8686fe24fe";
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
