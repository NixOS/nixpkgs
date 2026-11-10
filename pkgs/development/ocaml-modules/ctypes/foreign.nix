{
  lib,
  stdenv,
  ocaml,
  buildDunePackage,
  ctypes,
  dune-configurator,
  libffi,
  ounit2,
  lwt,
}:

buildDunePackage {
  pname = "ctypes-foreign";

  inherit (ctypes) version src;

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [
    ctypes
    libffi
  ];

  checkInputs = [
    ounit2
    lwt
  ];

  # Fix build with gcc 14
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  # closure lifetime tests crash on darwin ocaml 5.5
  doCheck = !(stdenv.hostPlatform.isDarwin && lib.versionAtLeast ocaml.version "5.5");

  meta = ctypes.meta // {
    description = "Dynamic access to foreign C libraries using Ctypes";
  };
}
