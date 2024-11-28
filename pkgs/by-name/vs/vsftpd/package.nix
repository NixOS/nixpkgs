{ lib, stdenv, fetchurl, libcap, libseccomp, openssl, pam, libxcrypt, nixosTests }:

stdenv.mkDerivation rec {
  pname = "vsftpd";
  version = "3.0.5";

  src = fetchurl {
    url = "https://security.appspot.com/downloads/vsftpd-${version}.tar.gz";
    sha256 = "sha256-JrYCrkVLC6bZnvRKCba54N+n9nIoEGc23x8njHC8kdM=";
  };

  buildInputs = [ libcap openssl libseccomp pam libxcrypt ];

  patches = [ ./CVE-2015-1419.patch ];

  postPatch = ''
    sed -i "/VSF_BUILD_SSL/s/^#undef/#define/" builddefs.h

    substituteInPlace Makefile \
      --replace -dirafter "" \
      --replace /usr $out \
      --replace /etc $out/etc \
      --replace "-Werror" ""


    mkdir -p $out/sbin $out/man/man{5,8}
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  NIX_LDFLAGS = "-lcrypt -lssl -lcrypto -lpam -lcap -lseccomp";

  enableParallelBuilding = true;

  passthru = {
    tests = { inherit (nixosTests) vsftpd; };
  };

  meta = with lib; {
    description = "Very secure FTP daemon";
    mainProgram = "vsftpd";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
