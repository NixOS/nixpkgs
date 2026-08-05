{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  mock,
  pbr,
  pyyaml,
  setuptools,
  six,
  multi-key-dict,
  testscenarios,
  requests,
  requests-mock,
  stestrCheckHook,
  multiprocess,
}:

buildPythonPackage rec {
  pname = "python-jenkins";
  version = "1.8.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "python_jenkins";
    inherit version;
    hash = "sha256-j0dhw5GsEejB8j93EBCSDBBEBJdwWrcXXVI1j1oS3Jg=";
  };

  # test uses timeout mechanism unsafe for use with the "spawn"
  # multiprocessing backend used on macos
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace tests/test_jenkins_sockets.py \
      --replace test_jenkins_open_no_timeout dont_test_jenkins_open_no_timeout
  '';

  pythonRelaxDeps = [ "setuptools" ];

  buildInputs = [ mock ];
  propagatedBuildInputs = [
    pbr
    pyyaml
    setuptools
    six
    multi-key-dict
    requests
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    stestrCheckHook
    testscenarios
    requests-mock
    multiprocess
  ];

  disabledTests = [
    # Skip tests that fail due to setuptools>=66.0.0 rejecting PEP 440
    # non-conforming versions. See
    # https://github.com/pypa/setuptools/issues/2497 for details.
    "tests.test_plugins.PluginsTestScenarios.test_plugin_version_comparison"
    "tests.test_plugins.PluginsTestScenarios.test_plugin_version_object_comparison"
    "tests.test_plugins.PluginsTest.test_plugin_equal"
    "tests.test_plugins.PluginsTest.test_plugin_not_equal"
  ];

  meta = {
    description = "Python bindings for the remote Jenkins API";
    homepage = "https://pypi.org/project/python-jenkins/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gador ];
  };
}
