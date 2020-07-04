{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "flaky";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8cd5455bb00c677f787da424eaf8c4a58a922d0e97126d3085db5b279a98b698";
  };

  checkInputs = [ mock nose pytest ];

  checkPhase = ''
    # based on tox.ini
    pytest -k 'example and not options' --doctest-modules test/test_pytest/
    pytest -k 'example and not options' test/test_pytest/
    pytest -p no:flaky test/test_pytest/test_flaky_pytest_plugin.py
    nosetests --with-flaky --force-flaky --max-runs 2 test/test_nose/test_nose_options_example.py
    pytest --force-flaky --max-runs 2  test/test_pytest/test_pytest_options_example.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/box/flaky";
    description = "Plugin for nose or py.test that automatically reruns flaky tests";
    license = licenses.asl20;
  };

}
