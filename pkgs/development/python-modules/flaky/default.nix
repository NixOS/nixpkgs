{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "flaky";
  version = "3.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OtEAeAchoZEfV6FlgJt+omWnhjMFrLZnCCIIIMr4qg0=";
  };

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
    homepage = "https://github.com/box/flaky";
    description = "Plugin for nose or py.test that automatically reruns flaky tests";
    license = licenses.asl20;
  };

}
