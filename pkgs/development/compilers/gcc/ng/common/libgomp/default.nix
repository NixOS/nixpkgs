{
  lib,
  stdenv,
  gcc_meta,
  release_version,
  version,
  getVersionFile,
  autoreconfHook269,
  monorepoSrc ? null,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libgomp";
  inherit version;

  src = monorepoSrc;

  patches = [
    (getVersionFile "gcc/custom-threading-model.patch")
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook269
  ];

  postPatch = ''
    sourceRoot=$(readlink -e "./libgomp")
  '';

  preConfigure = ''
    mkdir ../build
    cd ../build
    configureScript=$sourceRoot/configure
    chmod +x "$configureScript"
  '';

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/";
  };
})
