{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  zlib,
  openssl,
  libarchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xbps";
  version = "0.60.6";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "xbps";
    tag = finalAttrs.version;
    hash = "sha256-euV8oi1na+mfILnnUHK5S8Pi6+QuOUA8KhD0FHUqM70=";
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
