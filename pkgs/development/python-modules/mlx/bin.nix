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

  disabled = !(srcs ? "${pythonVersion}-${stdenv.hostPlatform.system}");

  src =
    srcs."${pythonVersion}-${stdenv.hostPlatform.system}"
      or (throw "mlx-bin is only supported on Python ${builtins.concatStringsSep ", " (builtins.attrNames srcs)}");

  # Upstream pins the Metal runtime to the same release as the Python wheel.
  dependencies =
    assert lib.assertMsg (mlx-metal.version == finalAttrs.version)
      "mlx-bin ${finalAttrs.version} requires mlx-metal ${finalAttrs.version}, but got ${mlx-metal.version}";
    [ mlx-metal ];

  postInstall = ''
    # The Python wheel expects libmlx.dylib and mlx.metallib to live under
    # mlx/lib next to the extension module, but those files are shipped by the
    # separate mlx-metal wheel.
    ln -s ${mlx-metal}/${python.sitePackages}/mlx/lib $out/${python.sitePackages}/mlx/lib
  '';

  pythonImportsCheck = [ "mlx" ];

  passthru.updateScript = callPackage ./update-wheels.nix { };

  passthru.srcs = srcs // {
    metal = mlx-metal.src;
    testSource = fetchFromGitHub {
      owner = "ml-explore";
      repo = "mlx";
      tag = "v${finalAttrs.version}";
      hash = wheelSources.testSourceHash;
    };
  };

  passthru.tests = callPackage ./tests.nix {
    mlx = finalAttrs.finalPackage;
    metalSupport = true;
    src = finalAttrs.passthru.srcs.testSource;
  };

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
