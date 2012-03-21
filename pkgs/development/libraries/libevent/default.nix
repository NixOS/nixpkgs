{stdenv, fetchurl}:

let version = "2.0.17"; in
stdenv.mkDerivation {
  name = "libevent-${version}";

  src = fetchurl {
    url = "https://github.com/downloads/libevent/libevent/libevent-${version}-stable.tar.gz";
    sha256 = "51735d1241f9f6d2d6465d8abc76f7511764f6de7d81026120c629612296faa6";
  };

  meta = {
    description = "libevent, an event notification library";

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
  };
}
