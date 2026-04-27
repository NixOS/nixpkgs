{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  flit-core,

  # dependencies
  absl-py,
  jax,
  jaxlib,
  numpy,
  toolz,
  typing-extensions,

  # tests
  cloudpickle,
  dm-tree,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "chex";
  version = "0.1.91";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "chex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lJ9+kvG7dRtfDVgvkcJ9/jtnX0lMfxY4mmZ290y/74U=";
  };

  patches = [
    # jax.device_put_replicated is removed in jax 0.10.0
    # This fix was merged upstream -> remove when updating to the next release
    (fetchpatch {
      url = "https://github.com/google-deepmind/chex/commit/5fbd2c9a9936799daf92354e0307b9e88b9cc163.patch";
      excludes = [
        "chex/_src/variants.py"
      ];
      hash = "sha256-ZTimSq7/yt2UEiWmLcfFBadX8+VcaxuPhkQJEyiEZlE=";
    })
  ];

  build-system = [
    flit-core
  ];

  dependencies = [
    absl-py
    jax
    jaxlib
    numpy
    toolz
    typing-extensions
  ];

  pythonImportsCheck = [ "chex" ];

  nativeCheckInputs = [
    cloudpickle
    dm-tree
    pytestCheckHook
  ];

  disabledTests = [
    # Jax 0.8.2 incompatibility (reported at https://github.com/google-deepmind/chex/issues/422)
    # AssertionError: AssertionError not raised
    "test_assert_tree_is_on_device"
    # AssertionError: "\[Chex\]\ [\s\S]*sharded arrays are disallowed" does not match ...
    "test_assert_tree_is_on_host"
    # AssertionError: [Chex] Assertion assert_tree_is_sharded failed: ...
    "test_assert_tree_is_sharded"
  ];

  meta = {
    description = "Library of utilities for helping to write reliable JAX code";
    homepage = "https://github.com/deepmind/chex";
    changelog = "https://github.com/google-deepmind/chex/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
})
