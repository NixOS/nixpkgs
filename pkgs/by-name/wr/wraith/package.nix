{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  replaceVars,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wraith";
  version = "1.4.10-unstable-2024-03-19";

  src = fetchFromGitHub {
    owner = "wraith";
    repo = "wraith";
    rev = "5e463847f86b5e72554bd895224a79a44091c59d";
    hash = "sha256-zKF8CVwj7LvkIgXIwQLC2vgBG7nL8RhoMov8YNdm9dc=";
    fetchSubmodules = true;
  };
  hardeningDisable = [ "format" ];
  buildInputs = [ openssl ];
  patches = [
    (replaceVars ./configure.patch {
      openssl-lib = "${lib.getLib openssl}/lib";
      openssl-include = "${lib.getDev openssl}/include";
    })
    (replaceVars ./remove-git-dep.patch {
      rev = finalAttrs.src.rev;
      rev-short = lib.sources.shortRev finalAttrs.src.rev;
      version = finalAttrs.version;
    })
  ];
  configureFlags = [
    "SSL_LIBDIR=${lib.getLib openssl}/lib"
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp -a wraith $out/bin/wraith
    ln -s wraith $out/bin/hub
  '';

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "IRC channel management bot written purely in C/C++";
    longDescription = ''
      Wraith is an IRC channel management bot written purely in C/C++. It has
      been in development since late 2003. It is based on Eggdrop 1.6.12 but has
      since evolved into something much different at its core. TCL and loadable
      modules are currently not supported.

      Maintainer's Notes:
      Copy the binary out of the store before running it with the -C option to
      configure it. See https://github.com/wraith/wraith/wiki/GettingStarted .

      The binary will not run when moved onto non-NixOS systems; use patchelf
      to fix its runtime dependenices.
    '';
    homepage = "https://wraith.botpack.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
