{
  lib,
  buildDunePackage,
  fetchFromGitHub,

  flint,
  zarith,
  ctypes,
  dune-configurator,
}:

buildDunePackage (finalAttrs: {
  pname = "flint";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "bobot";
    repo = "ocaml-flint";
    tag = finalAttrs.version;
    hash = "sha256-VEAyLKXH7SNnoSML4uFV2b4vI93+Tar7ZhBW1oqFQCM=";
  };

  dontConfigure = true; # ./configure directory

  propagatedBuildInputs = [
    flint
    zarith
    ctypes
    dune-configurator
  ];

  meta = {
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ luc65r ];
  };
})
