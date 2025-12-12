{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  libcap,
  libseccomp,
  openssl,
  pam,
  libxcrypt,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vsftpd";
  version = "3.0.5";

  src = fetchurl {
    url = "https://security.appspot.com/downloads/vsftpd-${finalAttrs.version}.tar.gz";
    hash = "sha256-JrYCrkVLC6bZnvRKCba54N+n9nIoEGc23x8njHC8kdM=";
  };

  buildInputs = [
    libcap
    openssl
    libseccomp
    pam
    libxcrypt
  ];

  patches = [
    ./CVE-2015-1419.patch

    # Fix build with gcc15
    (fetchpatch {
      name = "vsftpd-correct-the-definition-of-setup_bio_callbacks-in-ssl.patch";
      url = "https://src.fedoraproject.org/rpms/vsftpd/raw/c31087744900967ff4d572706a296bf6c8c4a68e/f/0076-Correct-the-definition-of-setup_bio_callbacks-in-ssl.patch";
      hash = "sha256-eYiY2eKQ+qS3CiRZYGuRHcnAe32zLDdb/GwF6NyHch4=";
    })
  ];

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

  meta = {
    description = "Very secure FTP daemon";
    mainProgram = "vsftpd";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.linux;
  };
})
