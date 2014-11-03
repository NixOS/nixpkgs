{ stdenv, fetchurl, python }:

let version = "2.0.21"; in
stdenv.mkDerivation {
  name = "libevent-${version}";

  src = fetchurl {
    url = "https://github.com/downloads/libevent/libevent/libevent-${version}-stable.tar.gz";
    sha256 = "1xblymln9vihdmf1aqkp8chwvnhpdch3786bh30bj75slnl31992";
  };

  patchPhase = ''
    substituteInPlace event_rpcgen.py \
      --replace "/usr/bin/env python2" "${python}/bin/python"
  '';

  meta = {
    description = "Event notification library";

    longDescription =
      '' The libevent API provides a mechanism to execute a callback function
         when a specific event occurs on a file descriptor or after a timeout
         has been reached.  Furthermore, libevent also support callbacks due
         to signals or regular timeouts.

         libevent is meant to replace the event loop found in event driven
         network servers.  An application just needs to call event_dispatch()
         and then add or remove events dynamically without having to change
         the event loop.
      '';

    license = "mBSD";
    platforms = stdenv.lib.platforms.all;
  };
}
