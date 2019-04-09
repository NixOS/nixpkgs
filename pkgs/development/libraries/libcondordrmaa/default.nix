{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libcondordrmaa-${version}";
  version = "1.6.2";

  src = fetchurl {
    url = "http://parrot.cs.wisc.edu/externals/drmaa-${version}.tar.gz";
    sha256 = "0yxrlp38qj60b5f74anlnr89ihijs2kmig9y0rwxwzian59cyawh";
  };

  soext = stdenv.hostPlatform.extensions.sharedLibrary;

  installPhase = ''
    install -Dm755 libdrmaa${soext} "$out"/lib/libdrmaa${soext}
    install -Dm644 drmaa.h "$out"/include/drmaa.h
  '';

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "Implementation of DRMAA 1.0 API on top of htcondor CLI";
    homepage = https://sourceforge.net/projects/condor-ext/;
    license = licenses.asl20;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
