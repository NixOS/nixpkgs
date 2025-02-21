{ mkDerivation
, lib
, extra-cmake-modules
, libksysguard
, libnl
, lm_sensors
, networkmanager-qt
}:

mkDerivation {
  pname = "ksystemstats";
  env.NIX_CFLAGS_COMPILE = toString [ "-I${lib.getBin libksysguard}/share" ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ libksysguard libnl lm_sensors networkmanager-qt ];
}
