{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyarrow,
  typing-extensions,
  ipython,
  numpy,
  pandas,
  pytest-timeout,
  pytestCheckHook,
  requests,
  torch,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyter-mimetypes";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datalayer";
    repo = "jupyter-mimetypes";
    # Upstream does not tag releases; this is the "bump: 0.2.0" commit.
    rev = "53d886c2e585cf0695cd39bae364168a10684bcf";
    hash = "sha256-1jOETqY2JYKc3CHXlGFYaPt4Pcx2osiqtnTIAE8MTh8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pyarrow
    typing-extensions
  ];

  nativeCheckInputs = [
    ipython
    numpy
    pandas
    pytest-timeout
    pytestCheckHook
    requests
    torch
    writableTmpDirAsHomeHook
  ];

  # These tests expect pandas DataFrame and Series to be serialized with Arrow,
  # but with pandas 3 they are serialized with pickle: jupyter-mimetypes picks
  # Arrow by the type's module path ("pandas.core.frame", "pandas.core.series"),
  # which pandas 3 changed to "pandas". Pickle still round-trips them correctly.
  disabledTests = [
    "test_serialize_dataframe"
    "test_serialize_series"
    "test_serialize_object_dataframe"
    "test_serialize_object_series"
    "test_repr_mimebundle_data_types"
    "test_repr_mimebundle_with_filters"
    "test_memory_usage_with_large_dataframes"
    "test_get_serialized_type_dataframe"
    "test_get_serialized_type_series"
    "test_get_mimetype_funcs_for_obj_dataframe"
    "test_get_mimetype_funcs_for_obj_series"
  ];

  pythonImportsCheck = [ "jupyter_mimetypes" ];

  meta = {
    description = "Proxy objects for Arrow- and pickle-based serialization of Python objects in Jupyter MIME bundles";
    homepage = "https://github.com/datalayer/jupyter-mimetypes";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ryota2357 ];
  };
})
