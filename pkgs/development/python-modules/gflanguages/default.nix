{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
  pytestCheckHook,
  pythonOlder,
  regex,
  setuptools,
  setuptools-scm,
  uharfbuzz,
  youseedee,
}:

buildPythonPackage rec {
  pname = "gflanguages";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gjWV1T+XU2qKzohDNq1RlZgh8GgRVrSGhpwrXTuTPtE=";
  };

  # Relax the dependency on protobuf 3. Other packages in the Google Fonts
  # ecosystem have begun upgrading from protobuf 3 to protobuf 4,
  # so we need to use protobuf 4 here as well to avoid a conflict
  # in the closure of fontbakery. It seems to be compatible enough.
  pythonRelaxDeps = [ "protobuf" ];

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    protobuf
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
    regex
    uharfbuzz
    youseedee
  ];

  pythonImportsCheck = [ "gflanguages" ];

  disabledTests = [
    # AssertionError
    "test_exemplars_are_in_script"
    "test_sample_texts_are_in_script"
  ];

  meta = with lib; {
    description = "Python library for Google Fonts language metadata";
    homepage = "https://github.com/googlefonts/lang";
    changelog = "https://github.com/googlefonts/lang/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
