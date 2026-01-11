{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  gettext,
  boost,
  cpio,
  elfutils,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "systemtap";
  version = "5.4";

  src = fetchgit {
    url = "git://sourceware.org/git/systemtap.git";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-11ecQFiBaWOZcbS5Qqf/41heiJM1wSttx0eMoVQImZc=";
  };

  nativeBuildInputs = [
    pkg-config
    cpio
    python3
    python3.pkgs.setuptools
  ];
  buildInputs = [
    boost
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
