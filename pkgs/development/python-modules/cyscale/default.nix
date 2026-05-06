{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  more-itertools,
  base58,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cyscale";
  version = "0.3.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "latent-to";
    repo = "cyscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L75xuo4LWfTMs1XYV8zSPtmxqgjWin9wcALDUjz5L1k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    more-itertools
    base58
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # test_valid_type_registry_presets walks ../scalecodec/type_registry relative
  # to the test file, which no longer exists after removing the source package dir
  disabledTests = [ "test_valid_type_registry_presets" ];

  # remove source package so tests import the installed Cython extensions, not the .pyx sources
  preCheck = ''
    rm -rf scalecodec
  '';

  pythonImportsCheck = [ "scalecodec" ];

  meta = {
    description = "Cython-accelerated SCALE codec library for Substrate-based blockchains (Polkadot, Kusama, Bittensor, etc.)";
    longDescription = "A drop-in replacement for py-scale-codec — same scalecodec module name, same public API, compiled with Cython for improved throughput.";
    homepage = "https://github.com/latent-to/cyscale";
    changelog = "https://github.com/latent-to/cyscale/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
