{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  texinfo,
  xfsprogs,
  e2fsprogs,
  libcap,
  ntfs3g,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wipefreespace";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "bogdro";
    repo = "wipefreespace";
    tag = finalAttrs.version;
    hash = "sha256-zWjMCWQNPPly8xJ7jQraGHi4OLuNrnpNVQC2CRyHUlw=";
  };

  nativeBuildInputs = [
    gettext
    texinfo
    xfsprogs
  ];

  # missed: Reiser3 FAT12/16/32 MinixFS HFS+ OCFS
  buildInputs = [
    e2fsprogs
    libcap
    ntfs3g
    xfsprogs
  ];

  strictDeps = true;

  meta = {
    description = "Program which will securely wipe the free space";
    homepage = "https://wipefreespace.sourceforge.io";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kyehn ];
    mainProgram = "wipefreespace";
  };
})
