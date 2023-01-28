{ qtModule
, lib
, stdenv
, qtbase
, qtquick3d
}:

qtModule {
  pname = "qtquick3dphysics";
  qtInputs = [ qtbase qtquick3d ];
  NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.isDarwin && stdenv.isx86_64)
    "-faligned-allocation";
}
