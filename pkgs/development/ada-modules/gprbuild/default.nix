{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, gprbuild-boot
, which
, gnat
, xmlada
}:

stdenv.mkDerivation {
  pname = "gprbuild";

  # See ./boot.nix for an explanation of the gprbuild setupHook,
  # our custom knowledge base entry and the situation wrt a
  # (future) gprbuild wrapper.
  inherit (gprbuild-boot)
    version
    src
    setupHooks
    meta
    ;

  nativeBuildInputs = [
    gnat
    gprbuild-boot
    which
  ];

  propagatedBuildInputs = [
    xmlada
  ];

  makeFlags = [
    "ENABLE_SHARED=${if stdenv.hostPlatform.isStatic then "no" else "yes"}"
    "PROCESSORS=$(NIX_BUILD_CORES)"
    # confusingly, for gprbuild --target is autoconf --host
    "TARGET=${stdenv.hostPlatform.config}"
    "prefix=${placeholder "out"}"
  ] ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
    "LIBRARY_TYPE=relocatable"
  ];

  # Fixes gprbuild being linked statically always. Based on the AUR's patch:
  # https://aur.archlinux.org/cgit/aur.git/plain/0001-Makefile-build-relocatable-instead-of-static-binary.patch?h=gprbuild&id=bac524c76cd59c68fb91ef4dfcbe427357b9f850
  patches = lib.optionals (!stdenv.hostPlatform.isStatic) [
    ./gprbuild-relocatable-build.patch
  ];

  buildFlags = [ "all" "libgpr.build" ];

  installFlags = [ "all" "libgpr.install" ];

  # link gprconfig_kb db from gprbuild-boot into build dir,
  # the install process copies its contents to $out
  preInstall = ''
    ln -sf ${gprbuild-boot}/share/gprconfig share/gprconfig
  '';

  # no need for the install script
  postInstall = ''
    rm $out/doinstall
  '';
}
