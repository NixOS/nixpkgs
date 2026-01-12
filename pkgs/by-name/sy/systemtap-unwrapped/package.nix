{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  gettext,
  cpio,
  elfutils,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "systemtap";
  version = "5.2";

  src = fetchgit {
    url = "git://sourceware.org/git/systemtap.git";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-SUPNarZW8vdK9hQaI2kU+rfKWIPiXB4BvJvRNC1T9tU=";
  };

  nativeBuildInputs = [
    pkg-config
    cpio
    python3
    python3.pkgs.setuptools
  ];
  buildInputs = [
    elfutils
    gettext
    python3
  ];
  enableParallelBuilding = true;

  meta = {
    homepage = "https://sourceware.org/systemtap/";
    description = "Provides a scripting language for instrumentation on a live kernel plus user-space";
    license = lib.licenses.gpl2;
    platforms = lib.systems.inspect.patterns.isGnu;
  };
})
