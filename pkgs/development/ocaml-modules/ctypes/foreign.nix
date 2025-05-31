{
  buildDunePackage,
  ctypes,
  dune-configurator,
  libffi,
  ounit2,
  lwt,
}:

buildDunePackage {
  pname = "ctypes-foreign";

  inherit (ctypes) version src doCheck;

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

  meta = ctypes.meta // {
    description = "Dynamic access to foreign C libraries using Ctypes";
  };
}
