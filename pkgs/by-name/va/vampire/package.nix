{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  z3,
  # We use an older version of z3 because upstream pins this older version as a submodule
  # And doesn't recommend using different versions unless you know specfically what you are doing
  z3' ? z3.overrideAttrs rec {
    version = "4.14.0";
    src = fetchFromGitHub {
      owner = "Z3Prover";
      repo = "z3";
      rev = "z3-${version}";
      hash = "sha256-Bv7+0J7ilJNFM5feYJqDpYsOjj7h7t1Bx/4OIar43EI=";
    };
  },
  vampire,
  nix-update-script,
  buildType ? "Release",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vampire";
  version = "5.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "vprover";
    repo = "vampire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zPE2GmaHupBhyPEZFcoRADzClPKYydlJ74dNkyQpJa8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ z3' ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" buildType)
    (
      if z3' != null then
        lib.cmakeFeature "Z3_DIR" "${z3'.dev}/lib/cmake"
      else
        lib.cmakeFeature "CMAKE_DISABLE_FIND_PACKAGE_Z3" "On"
    )
  ];

  prePatch = ''
    rm -rf z3
  '';

  doCheck = buildType == "Debug";
  preCheck = ''
    make vtest -j $NIX_BUILD_CORES
  '';

  passthru = {
    updateScript = nix-update-script { };
    z3 = z3';
    tests.debug-build-with-tests = vampire.override {
      buildType = "Debug";
    };
  };

  meta = {
    homepage = "https://vprover.github.io/";
    description = "Vampire Theorem Prover";
    mainProgram = "vampire";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sempiternal-aurora ];
  };
})
