{ lib, stdenv, fetchurl }:

let
  version = "0.6";
  sha256 = "057zhgy9w4y8z2996r0pq5k2k39lpvmmvz4df8db8qa9f6hvn1b7";

in
stdenv.mkDerivation {
  pname = "bearssl";
  inherit version;

  src = fetchurl {
    url = "https://www.bearssl.org/bearssl-${version}.tar.gz";
    inherit sha256;
  };

  outputs = [ "bin" "lib" "dev" "out" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -D build/brssl $bin/brssl
    install -D build/testcrypto $bin/testcrypto
    install -Dm644 build/libbearssl.so $lib/lib/libbearssl.so
    install -Dm644 build/libbearssl.a $lib/lib/libbearssl.a
    install -Dm644 -t $dev/include inc/*.h
    touch $out
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.bearssl.org/";
    description = "An implementation of the SSL/TLS protocol written in C";
    longDescription = ''
      BearSSL is an implementation of the SSL/TLS protocol (RFC 5246)
      written in C. It aims at offering the following features:

      * Be correct and secure. In particular, insecure protocol versions and
        choices of algorithms are not supported, by design; cryptographic
        algorithm implementations are constant-time by default.

      * Be small, both in RAM and code footprint. For instance, a minimal
        server implementation may fit in about 20 kilobytes of compiled code
        and 25 kilobytes of RAM.

      * Be highly portable. BearSSL targets not only “big” operating systems
        like Linux and Windows, but also small embedded systems and even
        special contexts like bootstrap code.

      * Be feature-rich and extensible. SSL/TLS has many defined cipher
        suites and extensions; BearSSL should implement most of them, and
        allow extra algorithm implementations to be added afterwards,
        possibly from third parties.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.Profpatsch ];
  };

}
