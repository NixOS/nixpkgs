{ stdenv, fetchurl, openssl, findutils }:

stdenv.mkDerivation rec {
  name = "libevent-${version}";
  version = "2.1.8";

  src = fetchurl {
    url = "https://github.com/libevent/libevent/releases/download/release-${version}-stable/libevent-${version}-stable.tar.gz";
    sha256 = "1hhxnxlr0fsdv7bdmzsnhdz16fxf3jg2r6vyljcl3kj6pflcap4n";
  };

  # libevent_openssl is moved into its own output, so that openssl isn't present
  # in the default closure.
  outputs = [ "out" "dev" "openssl" ];
  outputBin = "dev";
  propagatedBuildOutputs = [ "out" "openssl" ];

  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isCygwin findutils;

  postInstall = ''
    moveToOutput "lib/libevent_openssl*" "$openssl"
    substituteInPlace "$dev/lib/pkgconfig/libevent_openssl.pc" \
      --replace "$out" "$openssl"
    sed "/^libdir=/s|$out|$openssl|" -i "$openssl"/lib/libevent_openssl.la
  '';

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
