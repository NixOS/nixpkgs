{
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  fetchPypi,
  lib,
  mlx-metal,
  python,
  stdenv,
}:

let
  wheelSources = import ./wheel-sources.nix;
  inherit (wheelSources) version;
  inherit (python) pythonVersion;
  sourceKey = "${pythonVersion}-${stdenv.hostPlatform.system}";

  getSrcFromPypi =
    {
      platform,
      dist,
      hash,
    }:
    fetchPypi {
      pname = "mlx";
      inherit
        version
        platform
        dist
        hash
        ;
      format = "wheel";
      python = dist;
      abi = dist;
    };

  srcs = lib.mapAttrs (_: source: getSrcFromPypi source) wheelSources.mlx;
in
buildPythonPackage (finalAttrs: {
  pname = "mlx";
  inherit version;
  format = "wheel";
  __structuredAttrs = true;

  disabled = !(srcs ? ${sourceKey});

  src = srcs.${sourceKey} or (throw "mlx-bin: unsupported Python version or system: ${sourceKey}");

  # Upstream pins the Metal runtime to the same release as the Python wheel.
  dependencies =
    assert lib.assertMsg (mlx-metal.version == finalAttrs.version)
      "mlx-bin ${finalAttrs.version} requires mlx-metal ${finalAttrs.version}, but got ${mlx-metal.version}";
    [ mlx-metal ];

  postInstall = ''
    # Nix installs the wheels separately, but MLX expects their files in the same package directory.
    ln -s ${mlx-metal}/${python.sitePackages}/mlx/lib $out/${python.sitePackages}/mlx/lib
    ln -s ${mlx-metal}/${python.sitePackages}/mlx/include $out/${python.sitePackages}/mlx/include
    ln -s ${mlx-metal}/${python.sitePackages}/mlx/share $out/${python.sitePackages}/mlx/share
  '';

  pythonImportsCheck = [ "mlx" ];

  passthru.updateScript = callPackage ./update-wheels.nix { };

  passthru.srcs = {
    mlx = srcs;
    mlx-metal = mlx-metal.srcs;
    testSource = fetchFromGitHub {
      owner = "ml-explore";
      repo = "mlx";
      tag = "v${finalAttrs.version}";
      hash = wheelSources.testSourceHash;
    };
  };

  passthru.tests.mlxTest =
    (callPackage ./tests.nix {
      mlx = finalAttrs.finalPackage;
      metalSupport = true;
      src = finalAttrs.passthru.srcs.testSource;
    }).mlxTest;

  meta = {
    description = "Prebuilt MLX wheel for Apple silicon with Metal runtime";
    homepage = "https://github.com/ml-explore/mlx";
    changelog = "https://github.com/ml-explore/mlx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      booxter
      kinnrai
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "aarch64-darwin" ];
  };
})
