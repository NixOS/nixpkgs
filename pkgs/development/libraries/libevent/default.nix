{ stdenv, fetchurl, autoreconfHook, openssl, python, findutils }:

let version = "2.0.22"; in
stdenv.mkDerivation {
  name = "libevent-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/levent/libevent-${version}-stable.tar.gz";
    sha256 = "18qz9qfwrkakmazdlwxvjmw8p76g70n3faikwvdwznns1agw9hki";
  };
  postPatch = "patchShebangs event_rpcgen.py";

  outputs = [ "dev" "out" ];
  outputBin = "dev";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl python ] ++ stdenv.lib.optional stdenv.isCygwin findutils;

  meta = with stdenv.lib; {
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

    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
