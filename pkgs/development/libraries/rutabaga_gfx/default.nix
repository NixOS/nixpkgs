{ lib, stdenv, fetchgit, cargo, pkg-config, rustPlatform
, aemu, gfxstream, libcap, libdrm, minijail
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rutabaga_gfx";
  version = "0.1.2";

  src = fetchgit {
    url = "https://chromium.googlesource.com/crosvm/crosvm";
    rev = "v${finalAttrs.version}-rutabaga-release";
    fetchSubmodules = true;
    hash = "sha256-0RJDKzeU7U6hc6CLKks8QcRs3fxN+/LYUbB0t6W790M=";
  };

  nativeBuildInputs = [ cargo pkg-config rustPlatform.cargoSetupHook ];
  buildInputs = [ aemu gfxstream ]
    ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform libdrm) libdrm;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-wuF3Isrp+u5J8jPQoPsIOWYGNKLSNa2pLfvladAWkLs=";
  };

  # make install always rebuilds
  dontBuild = true;

  makeFlags = [ "prefix=$(out)" ];

  preInstall = ''
    cd rutabaga_gfx/ffi
  '';

  meta = with lib; {
    homepage = "https://crosvm.dev/book/appendix/rutabaga_gfx.html";
    description = "cross-platform abstraction for GPU and display virtualization";
    license = licenses.bsd3;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.darwin ++ platforms.linux;
  };
})
