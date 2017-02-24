{ stdenv, fetchurl, openssl, findutils }:

let version = "2.0.22"; in
stdenv.mkDerivation {
  name = "libevent-${version}";

  src = fetchurl {
    url = "https://github.com/libevent/libevent/releases/download/release-${version}-stable/libevent-${version}-stable.tar.gz";
    sha256 = "18qz9qfwrkakmazdlwxvjmw8p76g70n3faikwvdwznns1agw9hki";
  };

  prePatch = let
      # https://lwn.net/Vulnerabilities/714581/
      debian = fetchurl {
        url = "http://http.debian.net/debian/pool/main/libe/libevent/"
            + "libevent_2.0.21-stable-3.debian.tar.xz";
        sha256 = "0b2syswiq3cvfbdvi4lbca15c31lilxnahax4a4b4qxi5fcab7h5";
      };
    in ''
      tar xf '${debian}'
      patches="$patches $(cat debian/patches/series | grep -v '^$\|^#' \
                          | grep -v '^20d6d445.patch' \
                          | grep -v '^dh-autoreconf' | sed 's|^|debian/patches/|')"
    '';

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isCygwin findutils;

  meta = with stdenv.lib; {
    description = "Event notification library";
    longDescription = ''
      The libevent API provides a mechanism to execute a callback function
      when a specific event occurs on a file descriptor or after a timeout
      has been reached.  Furthermore, libevent also support callbacks due
      to signals or regular timeouts.

      libevent is meant to replace the event loop found in event driven
      network servers.  An application just needs to call event_dispatch()
      and then add or remove events dynamically without having to change
      the event loop.
    '';
    homepage = http://libevent.org/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
