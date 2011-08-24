{stdenv, fetchurl}:

let version = "2.0.12"; in
stdenv.mkDerivation {
  name = "libevent-${version}";

  src = fetchurl {
    url = "http://monkey.org/~provos/libevent-${version}-stable.tar.gz";
    sha256 = "1az554fal8g822nhc9f1qrsx12y741x4ks9smj9ix20g5vvq60mc";
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
