{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  zlib,
  openssl,
  libarchive,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xbps";
  version = "0.60.7";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "xbps";
    tag = finalAttrs.version;
    hash = "sha256-noi+OAyBmLCBnmLDWEuNXEOPyqt9Qr1v4CNm7GjKXHA=";
  };

  nativeBuildInputs = [
    pkg-config
    which
  ];

  buildInputs = [
    zlib
    openssl
    libarchive
  ];

  patches = [
    ./cert-paths.patch
    # fix build w/ glibc-2.44
    (fetchpatch {
      url = "https://github.com/void-linux/xbps/commit/7d02b79d3d7e0bf644adf8b412e76dba1b1fdce1.patch";
      hash = "sha256-iUNBmkkfR02/EFDkax/ZpE7oM+5IVDMmD0FYz7p0dQ4=";
    })
    (fetchpatch {
      url = "https://github.com/void-linux/xbps/commit/9a8002c5688c3cdda700b022bf432b4426d64042.patch";
      hash = "sha256-/94HKeyv9LaQv6QHE0CqmM1ajBOSNt9Sfh0XKV0RLMQ=";
    })
    (fetchpatch {
      url = "https://github.com/void-linux/xbps/commit/7f2f10300f235639c5880bea1e4b14245fd5fbda.patch";
      hash = "sha256-iZXiNYrSFaP55qyzefc3hqJ+SoIOsFILqnra6u5iGpM=";
    })
    (fetchpatch {
      url = "https://github.com/void-linux/xbps/commit/84f6a1be26348c265afedebe9cea958424b0aabf.patch";
      hash = "sha256-WDsGkI+3JnJskM+UKjI/UZP6ypMCd5+3rYtlQgQEr40=";
    })
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-result -Wno-error=deprecated-declarations";

  # Don't try to install keys to /var/db/xbps, put in $out/share for now
  postPatch = ''
    substituteInPlace data/Makefile \
      --replace-fail '$(DESTDIR)/$(DBDIR)' '$(DESTDIR)/$(SHAREDIR)'
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/void-linux/xbps";
    description = "X Binary Package System";
    platforms = lib.platforms.linux; # known to not work on Darwin, at least
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
