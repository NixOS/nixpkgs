{ stdenv
, buildPythonPackage
, dm-haiku
, chex
, cloudpickle
, dill
, dm-tree
, jaxlib
, pytest-xdist
, pytestCheckHook
, tensorflow
, bsuite
, frozendict
, dm-env
, scikitimage
, rlax
, distrax
, tensorflow-probability
, optax }:

buildPythonPackage rec {
  pname = "dm-haiku-tests";
  inherit (dm-haiku) version;

  src = dm-haiku.testsout;

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    bsuite
    chex
    cloudpickle
    dill
    distrax
    dm-env
    dm-haiku
    dm-tree
    frozendict
    jaxlib
    pytest-xdist
    pytestCheckHook
    optax
    rlax
    scikitimage
    tensorflow
    tensorflow-probability
  ];

  disabledTests = [
    # See https://github.com/deepmind/dm-haiku/issues/366.
    "test_jit_Recurrent"
    # Assertion errors
    "test_connect_conv_padding_function_same0"
    "test_connect_conv_padding_function_valid0"
    "test_connect_conv_padding_function_same1"
    "test_connect_conv_padding_function_same2"
    "test_connect_conv_padding_function_valid1"
    "test_connect_conv_padding_function_valid2"
    "test_invalid_axis_ListString"
    "test_invalid_axis_String"
    "test_simple_case"
    "test_simple_case_with_scale"
    "test_slice_axis"
    "test_zero_inputs"
  ];

}
