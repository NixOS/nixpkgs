{ lib, stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libsodium";
  version = "1.0.18";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${pname}-${version}.tar.gz";
    sha256 = "1h9ncvj23qbbni958knzsli8dvybcswcjbx0qjjgi922nf848l3g";
  };

  outputs = [ "out" "dev" ];

  patches = lib.optional stdenv.targetPlatform.isMinGW ./mingw-no-fortify.patch;

  nativeBuildInputs = lib.optional stdenv.targetPlatform.isMinGW autoreconfHook;

  separateDebugInfo = stdenv.isLinux && stdenv.hostPlatform.libc != "musl";

  enableParallelBuilding = true;
  hardeningDisable = lib.optional (stdenv.targetPlatform.isMusl && stdenv.targetPlatform.isx86_32) "stackprotector";

  # FIXME: the hardeingDisable attr above does not seems effective, so
  # the need to disable stackprotector via configureFlags
  configureFlags = lib.optional (stdenv.targetPlatform.isMusl && stdenv.targetPlatform.isx86_32) "--disable-ssp";

  doCheck = true;

  meta = with lib; {
    description = "A modern and easy-to-use crypto library";
    homepage = "http://doc.libsodium.org/";
    license = licenses.isc;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
  };
}
