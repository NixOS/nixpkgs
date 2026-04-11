{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  jax,
  jaxlib,
  tensorflow-probability,

  # tests
  inference-gym,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "oryx";
  version = "0.2.9";
  pyproject = true;

  # No more tags on GitHub. See https://github.com/jax-ml/oryx/issues/95
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HlKUnguTNfs7gSqIJ0n2EjjLXPUgtI2JsQM70wKMeXs=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    jax
    jaxlib
    tensorflow-probability
  ];

  pythonImportsCheck = [ "oryx" ];

  nativeCheckInputs = [
    inference-gym
    pytestCheckHook
  ];

  disabledTests = [
    # ValueError: Number of devices 1 must equal the product of mesh_shape (1, 2)
    "test_plant"
    "test_plant_before_shmap"
    "test_plant_inside_shmap_fails"
    "test_reap"
    "test_reap_before_shmap"
    "test_reap_inside_shmap_fails"

    # ValueError: Variable has already been reaped
    "test_call_list"
    "test_call_tuple"
    "test_dense_combinator"
    "test_dense_function"
    "test_dense_imperative"
    "test_function_in_combinator_in_function"
    "test_grad_of_function_with_literal"
    "test_grad_of_shared_layer"
    "test_grad_of_stateful_function"
    "test_kwargs_rng"
    "test_kwargs_training"
    "test_kwargs_training_rng"
    "test_reshape_call"
    "test_scale_by_adam_should_scale_by_adam"
    "test_scale_by_schedule_should_update_scale"
    "test_scale_by_stddev_should_scale_by_stddev"
    "test_trace_should_keep_track_of_momentum_with_nesterov"

    # NotImplementedError: No registered inverse for `split`
    "test_inverse_of_split"

    # jax.errors.UnexpectedTracerError: Encountered an unexpected tracer
    "test_can_plant_into_jvp_of_custom_jvp_function_unimplemented"
    "test_forward_Scale"

    # ValueError: No variable declared for assign: update_1
    "test_optimizer_adam"
    "test_optimizer_noisy_sgd"
    "test_optimizer_rmsprop"
    "test_optimizer_sgd"
    "test_optimizer_sgd_with_momentum"
    "test_optimizer_sgd_with_nesterov_momentum"

    # AssertionError
    # ACTUAL: array(-2.337877, dtype=float32)
    # DESIRED: array(0., dtype=float32)
    "test_can_map_over_batches_with_vmap_and_reduce_to_scalar_log_prob"
    "test_vmapping_distribution_reduces_to_scalar_log_prob"

    # TypeError: _dot_general_shape_rule() missing 1 required keyword-only argument: 'out_sharding'
    "test_can_rewrite_dot_to_einsu"

    # AttributeError: 'float' object has no attribute 'shape'
    "test_add_noise_should_add_noise"
    "test_apply_every_should_delay_updates"

    # TypeError: Error interpreting argument to functools.partial(...) as an abstract array
    "test_can_rewrite_nested_expression_into_single_einsum"
  ];

  disabledTestPaths = [
    # ValueError: Variable has already been reaped
    "oryx/experimental/nn/normalization_test.py"
    "oryx/experimental/nn/pooling_test.py"
  ];

  meta = {
    description = "Library for probabilistic programming and deep learning built on top of Jax";
    homepage = "https://github.com/jax-ml/oryx";
    changelog = "https://github.com/jax-ml/oryx/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    # oryx seems to be incompatible with jax 0.5.1
    # 237 additional test failures are resulting from the jax bump.
    broken = true;
  };
}
