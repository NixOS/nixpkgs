{
  deployAndroidPackage,
  lib,
  package,
  os,
  arch,
  autoPatchelfHook,
  fetchurl,
  patchelf,
  pkgs,
  stdenv,
  meta,
}:

deployAndroidPackage {
  inherit package os arch;
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    # patchelf 0.19.2 corrupts the bundled ninja binary (NixOS/nixpkgs#577387).
    # FIXME: drop this override once a patchelf release contains
    # https://github.com/NixOS/patchelf/pull/672.
    (patchelf.overrideAttrs (
      finalAttrs: _: {
        version = "0.15.2";
        src = fetchurl {
          url = "https://github.com/NixOS/patchelf/releases/download/${finalAttrs.version}/patchelf-${finalAttrs.version}.tar.bz2";
          hash = "sha256-F3RfVkFZyOIo/EEtplogSLhGxLa0Igt3y/IkFuAvLXw=";
        };
      }
    ))
    autoPatchelfHook
  ];
  buildInputs = lib.optionals (os == "linux") [
    pkgs.stdenv.cc.libc
    pkgs.stdenv.cc.cc
    pkgs.ncurses5
  ];
  patchInstructions = lib.optionalString (os == "linux") ''
    autoPatchelf $packageBaseDir/bin
  '';

  meta = meta // {
    license = lib.licenses.bsd3;
  };
}
