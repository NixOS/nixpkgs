{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

let
  wheelSources = import ./wheel-sources.nix;
in
buildPythonPackage rec {
  pname = "mlx-metal";
  inherit (wheelSources) version;
  format = "wheel";
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "mlx_metal";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    abi = "none";
    inherit (wheelSources.mlx-metal) platform hash;
  };

  meta = {
    description = "Prebuilt Metal runtime for MLX";
    homepage = "https://github.com/ml-explore/mlx";
    changelog = "https://github.com/ml-explore/mlx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kinnrai ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "aarch64-darwin" ];
  };
}
