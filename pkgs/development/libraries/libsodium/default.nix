{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.17";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "1cf2d9v1gylz1qcy2zappbf526qfmph6gd6fnn3w2b347vixmhqc";
  };

  outputs = [ "out" "dev" ];
  separateDebugInfo = stdenv.isLinux;

  enableParallelBuilding = true;
  hardeningDisable = stdenv.lib.optional (stdenv.targetPlatform.isMusl && stdenv.targetPlatform.isx86_32) "stackprotector";

  # FIXME: the hardeingDisable attr above does not seems effective, so
  # the need to disable stackprotector via configureFlags
  configureFlags = stdenv.lib.optional (stdenv.targetPlatform.isMusl && stdenv.targetPlatform.isx86_32) "--disable-ssp";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A modern and easy-to-use crypto library";
    homepage = http://doc.libsodium.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
  };
}
