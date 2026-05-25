{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "mlx-metal";
  version = "0.31.2";
  format = "wheel";
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "mlx_metal";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    abi = "none";
    platform = "macosx_14_0_arm64";
    hash = "sha256-slOFvO4Y/BlAkiVbi1O5o9hInrZQ5ZFg8bV6rdB6otw=";
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
