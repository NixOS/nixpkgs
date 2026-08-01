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
  bashNonInteractive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "systemtap";
  version = "5.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchgit {
    url = "git://sourceware.org/git/systemtap.git";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-olN98hjIYZmQvI7Fn1v5ZwRl7yaCAPRGr2g33oMq7VQ=";
  };

  nativeBuildInputs = [
    pkg-config
    cpio
    gettext
    python3
    python3.pkgs.setuptools
  ];
  buildInputs = [
    boost
    elfutils
    python3
    bashNonInteractive
  ];
  enableParallelBuilding = true;

  meta = {
    homepage = "https://sourceware.org/systemtap/";
    description = "Provides a scripting language for instrumentation on a live kernel plus user-space";
    license = lib.licenses.gpl2;
    platforms = lib.systems.inspect.patterns.isGnu;
  };
})
