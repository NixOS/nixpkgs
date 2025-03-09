{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "memstream";
  version = "0.1";

  src = fetchurl {
    url = "https://piumarta.com/software/memstream/memstream-${version}.tar.gz";
    sha256 = "0kvdb897g7nyviaz72arbqijk2g2wa61cmi3l5yh48rzr49r3a3a";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'cc' '$(CC)'
  '';

  dontConfigure = true;

  postBuild = ''
    $AR rcs libmemstream.a memstream.o
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    runHook preCheck

    ./test | grep "This is a test of memstream"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -D libmemstream.a "$out"/lib/libmemstream.a
    install -D memstream.h "$out"/include/memstream.h

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.piumarta.com/software/memstream/";
    description = "memstream.c is an implementation of the POSIX function open_memstream() for BSD and BSD-like operating systems";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
