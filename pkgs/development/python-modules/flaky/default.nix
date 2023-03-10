{ lib
, buildPythonPackage
, fetchPypi
, mock
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "flaky";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ad100780721a1911f57a165809b7ea265a7863305acb66708220820caf8aa0d";
  };

  nativeCheckInputs = [ mock nose pytest ];

  checkPhase = ''
    # based on tox.ini
    pytest -k 'example and not options' --doctest-modules test/test_pytest/
    pytest -k 'example and not options' test/test_pytest/
    pytest -p no:flaky test/test_pytest/test_flaky_pytest_plugin.py
    nosetests --with-flaky --force-flaky --max-runs 2 test/test_nose/test_nose_options_example.py
    pytest --force-flaky --max-runs 2  test/test_pytest/test_pytest_options_example.py
  '';

  meta = with lib; {
    homepage = "https://github.com/box/flaky";
    description = "Plugin for nose or py.test that automatically reruns flaky tests";
    license = licenses.asl20;
  };

}
