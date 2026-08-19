{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  gfortran,
  meson,
  ninja,
  pkg-config,

  # buildInputs
  blas,
  lapack,
  cpcm-x,
  dftd4,
  mctc-lib,
  multicharge,
  numsa,
  simple-dftd3,
  tblite,
  test-drive,
  toml-f,

  # passthru
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtb";
  # No tagged release supports the tblite 0.6 / dftd4 4.2 API; the latest tag (6.7.1) targets
  # tblite 0.3. Track master, which builds against the current grimme-lab stack packaged in nixpkgs
  version = "6.7.1-unstable-2026-07-13";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = "xtb";
    rev = "b31754bf3c7cccf8c242c469b03ae675e04bd608";
    hash = "sha256-HLKSVP/U6rggFYE9l7e4rRBGxkdWCmiYf/KpsQmF3Yw=";
  };

  # The `solve`/`solve4` eigensolvers size the DSYGVD workspace from a `LWORK = -1` query.
  # OpenBLAS leaves `aux(1)` as a denormal/garbage value on that query, so `int(aux(1))` falls
  # below DSYGVD's documented minimum and the real call aborts with `DSYGVD parameter number 11 had
  # an illegal value` (it works against reference LAPACK, which fills the query correctly).
  # This surfaces as failures in the `gfn0` and `peeq` unit tests. Clamp the workspace sizes to the
  # LAPACK minima so the query result can only ever grow them.
  postPatch = ''
    substituteInPlace src/scc_core.f90 \
      --replace-fail "lwork=int(aux(1))"  "lwork=max(int(aux(1)),1+6*ndim+2*ndim**2)" \
      --replace-fail "lwork=int(aux4(1))" "lwork=max(int(aux4(1)),1+6*ndim+2*ndim**2)" \
      --replace-fail "liwork=iwork(1)"    "liwork=max(iwork(1),3+5*ndim)"
  '';

  nativeBuildInputs = [
    gfortran
    meson
    ninja
    pkg-config
  ];

  mesonFlags = [
    # Require the optional backends rather than letting the `auto` features
    # silently disable themselves if a dependency is not found.
    (lib.mesonEnable "tblite" true)
    (lib.mesonEnable "cpcmx" true)
  ];

  # Serialize the build: ninja otherwise compiles xtb's program/library objects before the
  # library's Fortran modules are generated.
  # `enableParallel` only controls the explicit -j flag and ninja parallelizes regardless, so the
  # race has to be killed with an explicit -j1.
  ninjaFlags = [ "-j1" ];

  buildInputs = [
    blas
    cpcm-x
    dftd4
    lapack
    mctc-lib
    multicharge
    numsa
    simple-dftd3
    tblite
    test-drive
    toml-f
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Semiempirical Extended Tight-Binding Program Package";
    homepage = "https://github.com/grimme-lab/xtb";
    # changelog = "https://github.com/grimme-lab/xtb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      sheepforce
    ];
    mainProgram = "xtb";
    platforms = lib.platforms.linux;
  };
})
