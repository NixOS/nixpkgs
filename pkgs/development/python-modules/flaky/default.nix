{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  mock,
  pytest,
}:

buildPythonPackage rec {
  pname = "flaky";
  version = "3.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RyBKgeyQXz1az71h2uq8raj51AMWFtm8sGGEYXKWmfU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytest
  ];

  checkPhase = ''
    # based on tox.ini
    pytest -k 'example and not options' --doctest-modules test/test_pytest/
    pytest -k 'example and not options' test/test_pytest/
    pytest -p no:flaky test/test_pytest/test_flaky_pytest_plugin.py
    pytest --force-flaky --max-runs 2  test/test_pytest/test_pytest_options_example.py
  '';

  meta = with lib; {
    changelog = "https://github.com/box/flaky/blob/v${version}/HISTORY.rst";
    homepage = "https://github.com/box/flaky";
    description = "Plugin for nose or py.test that automatically reruns flaky tests";
    license = licenses.asl20;
  };
}
