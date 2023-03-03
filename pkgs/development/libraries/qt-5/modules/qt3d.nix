{ lib, stdenv, qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qt3d";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
  # error: use of undeclared identifier 'stat64'
  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) "-Dstat64=stat";
}
