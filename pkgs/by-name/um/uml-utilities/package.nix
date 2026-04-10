{
  fetchFromGitLab,
  fuse,
  lib,
  readline,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uml-utilities";
  version = "20070815.4-2.1";

  src = fetchFromGitLab {
    owner = "uml-team";
    repo = "uml-utilities";
    domain = "salsa.debian.org";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-x9Aw73IcvYqfG4xMWUiMDLQPriuQ9qla98gIC9kXvY4=";
  };

  makeFlags = [
    "BIN_DIR=$(out)/bin"
    "LIB_DIR=$(lib)/lib/uml"
    "SBIN_DIR=$(out)/bin"
  ];

  env.NIX_CFLAGS_COMPILE = "-DFUSE_USE_VERSION=25";

  buildInputs = [
    fuse
    readline
  ];

  patches = [
    ./install-fix.patch
  ];

  outputs = [
    "out"
    "lib"
  ];

  meta = {
    description = "Tools for use with User Mode Linux";
    maintainers = with lib.maintainers; [
      maxhearnden
    ];
  };
})
