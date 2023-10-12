{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, mock
, pbr
, pyyaml
, setuptools
, six
, multi_key_dict
, testscenarios
, requests
, requests-mock
, stestr
, multiprocess
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "python-jenkins";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/18dklOdkD+GmwLq8rExREfm1tePdn7c/dkpZ9UyucY=";
  };

  # test uses timeout mechanism unsafe for use with the "spawn"
  # multiprocessing backend used on macos
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace tests/test_jenkins_sockets.py \
      --replace test_jenkins_open_no_timeout dont_test_jenkins_open_no_timeout
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];
  pythonRelaxDeps = [
    "setuptools"
  ];

  buildInputs = [ mock ];
  propagatedBuildInputs = [ pbr pyyaml setuptools six multi_key_dict requests ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ stestr testscenarios requests-mock multiprocess ];
  checkPhase = ''
    # Skip tests that fail due to setuptools>=66.0.0 rejecting PEP 440
    # non-conforming versions. See
    # https://github.com/pypa/setuptools/issues/2497 for details.
    stestr run -E "tests.test_plugins.(PluginsTestScenarios.test_plugin_version_comparison|PluginsTestScenarios.test_plugin_version_object_comparison|PluginsTest.test_plugin_equal|PluginsTest.test_plugin_not_equal)"
  '';

  meta = with lib; {
    description = "Python bindings for the remote Jenkins API";
    homepage = "https://pypi.python.org/pypi/python-jenkins";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };

}
