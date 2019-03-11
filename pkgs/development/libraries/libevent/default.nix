{ stdenv, fetchurl, fetchpatch, findutils, fixDarwinDylibNames
, sslSupport? true, openssl
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  name = "libevent-${version}";
  version = "2.1.8";

  src = fetchurl {
    url = "https://github.com/libevent/libevent/releases/download/release-${version}-stable/libevent-${version}-stable.tar.gz";
    sha256 = "1hhxnxlr0fsdv7bdmzsnhdz16fxf3jg2r6vyljcl3kj6pflcap4n";
  };

  #NOTE: Patches to support libressl-2.7. These are taken from libevent upstream, and can both be dropped with the next release.
  patches = [
    (fetchpatch {
      url = "https://github.com/libevent/libevent/commit/22dd14945c25600de3cf8b91000c66703b551e4f.patch";
      sha256 = "0fzcb241cp9mm7j6baw22blcglbc083ryigzyjaij8r530av10kd";
    })
    (fetchpatch {
      url = "https://github.com/libevent/libevent/commit/28b8075400c70b2d2da2ce07e590c2ec6d11783d.patch";
      sha256 = "0dkzlk44033xksg2iq5w90r3lnziwl1mgz291nzqq906zrya0sdb";
    })
  ];

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
