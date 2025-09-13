{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "zsync";
  version = "0.6.3-unstable-2025-05-29";

  src = fetchFromGitHub {
    owner = "cph6";
    repo = "zsync";
    rev = "a5cb28f923dd3cfdeb65e2930dd1faa727c2abf8";
    hash = "sha256-gJs1P83AKWGipspeoFCSibZH+X6mmj3aL4+yjGO2YJo=";
  };

  sourceRoot = "${src.name}/c";

  patches = [ ./remove-inexisting-rsumtest.patch ];

  makeFlags = [ "AR=${stdenv.cc.bintools.targetPrefix}ar" ];

  # Suppress error "call to undeclared library function 'strcasecmp'" during compilation.
  # The function is found by the linker correctly, so this doesn't introduce any issues.
  # Also suppress errors that come from incompatible pointer types due to GCC 14 changes.
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-implicit-function-declaration"
    ]
    ++ lib.optionals stdenv.cc.isGNU [
      "-Wno-error=incompatible-pointer-types"
    ]
  );

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    homepage = "https://github.com/cph6/zsync";
    description = "File distribution system using the rsync algorithm";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [
      viric
      ryand56
    ];
    platforms = with lib.platforms; all;
  };
}
