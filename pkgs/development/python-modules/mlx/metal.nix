{
  buildPythonPackage,
  callPackage,
  fetchPypi,
  lib,
  macosVariant ? "14",
}:

let
  wheelSources = import ./wheel-sources.nix;
  srcs = lib.mapAttrs (
    _: source:
    fetchPypi {
      pname = "mlx_metal";
      inherit (wheelSources) version;
      format = "wheel";
      dist = "py3";
      python = "py3";
      abi = "none";
      inherit (source) platform hash;
    }
  ) wheelSources.mlx-metal;
in
buildPythonPackage rec {
  pname = "mlx-metal";
  inherit (wheelSources) version;
  format = "wheel";
  __structuredAttrs = true;

  src = srcs.${macosVariant} or (throw "mlx-metal: unsupported macOS wheel variant ${macosVariant}");

  passthru = {
    inherit macosVariant srcs;
    updateScript = callPackage ./update-wheels.nix { };
  };

  meta = {
    description = "Prebuilt Metal runtime for MLX";
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
}
