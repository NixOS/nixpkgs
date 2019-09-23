{ stdenv, fetchurl, findutils, fixDarwinDylibNames
, sslSupport? true, openssl
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  pname = "libevent";
  version = "2.1.11";

  src = fetchurl {
    url = "https://github.com/libevent/libevent/releases/download/release-${version}-stable/libevent-${version}-stable.tar.gz";
    sha256 = "0g988zqm45sj1hlhhz4il5z4dpi5dl74hzjwzl4md37a09iaqnx6";
  };

  # libevent_openssl is moved into its own output, so that openssl isn't present
  # in the default closure.
  outputs = [ "out" "dev" ]
    ++ stdenv.lib.optional sslSupport "openssl"
    ;
  outputBin = "dev";
  propagatedBuildOutputs = [ "out" ]
    ++ stdenv.lib.optional sslSupport "openssl"
    ;

  buildInputs = []
    ++ stdenv.lib.optional sslSupport openssl
    ++ stdenv.lib.optional stdenv.isCygwin findutils
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames
    ;

  doCheck = false; # needs the net

  postInstall = stdenv.lib.optionalString sslSupport ''
    moveToOutput "lib/libevent_openssl*" "$openssl"
    substituteInPlace "$dev/lib/pkgconfig/libevent_openssl.pc" \
      --replace "$out" "$openssl"
    sed "/^libdir=/s|$out|$openssl|" -i "$openssl"/lib/libevent_openssl.la
  '';

  enableParallelBuilding = true;

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
  };
}
