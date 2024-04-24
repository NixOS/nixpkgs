{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "publicsuffix";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Is4dZatq9emyEi4kQ/rNuT+1xKvyQTgJnLEP55ifQ7Y=";
  };

  # disable test_fetch and the doctests (which also invoke fetch)
  postPatch = ''
    sed -i -e "/def test_fetch/i\\
    \\t@unittest.skip('requires internet')" -e "/def additional_tests():/,+1d" tests.py
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "publicsuffix" ];

  meta = with lib; {
    description = "Allows to get the public suffix of a domain name";
    homepage = "https://pypi.python.org/pypi/publicsuffix/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
