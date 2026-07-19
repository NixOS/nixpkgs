{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,

  mkPythonMetaPackage,
  python,
  pythonImportsCheckHook,
  toPythonModule,

  llvmPackages_20,
  cmake,
  ninja,
  yj,

  apple-sdk,
  pybind11,
  vtk,
}:

let
  # Upstream requires a minimum of LLVM 20.
  llvmPackages = llvmPackages_20;

  # On Linux, we need to use a non-libcxx stdenv as we are compiling against
  # libraries built with libstdc++. On the other hand, the ocp-sources
  # derivation requires libcxx for unknowable reasons.
  stdenv = llvmPackages.stdenv;

  pythonBuildEnv = python.withPackages (
    ps: with ps; [
      click
      lief
      path
      (libclang.override { inherit llvmPackages; })
      toml
      pandas
      joblib
      tqdm
      jinja2
      toposort
      logzero
      pyparsing
      pybind11
      schema
    ]
  );

  ocp-sources = callPackage ./ocp-sources.nix { inherit llvmPackages pythonBuildEnv; };
  inherit (ocp-sources) version;
in
toPythonModule (
  stdenv.mkDerivation (finalAttrs: {
    pname = "cadquery-ocp";
    inherit version;
    src = ocp-sources;

    nativeBuildInputs =
      ocp-sources.nativeBuildInputs
      ++ lib.optional (stdenv.buildPlatform == stdenv.hostPlatform) pythonImportsCheckHook;
    inherit (ocp-sources) buildInputs;

    propagatedBuildInputs = [
      (mkPythonMetaPackage {
        inherit (finalAttrs) pname version meta;
        dependencies = [ vtk ];
      })
    ];

    env = {
      NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";
    };

    cmakeFlags = [ (lib.cmakeFeature "Python_ROOT_DIR" "${pythonBuildEnv}") ];

    separateDebugInfo = true;

    installPhase =
      let
        destDir = "$out/${python.sitePackages}";
      in
      ''
        runHook preInstall

        mkdir -p ${destDir}
        cp ./*.so ${destDir}

        runHook postInstall
      '';

    pythonImportsCheck = [
      "OCP"
      "OCP.gp"
    ];

    meta = {
      description = "Python wrapper for OCCT generated using pywrap";
      homepage = "https://github.com/CadQuery/OCP";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ tnytown ];
    };
  })
)
