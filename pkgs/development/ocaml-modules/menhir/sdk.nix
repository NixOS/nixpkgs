{
  lib,
  buildDunePackage,
  menhirLib,
}:

buildDunePackage {
  pname = "menhirSdk";

  inherit (menhirLib) version src;

  meta = menhirLib.meta // {
    description = "Compile-time library for auxiliary tools related to Menhir";
    license = lib.licenses.gpl2Only;
  };
}
