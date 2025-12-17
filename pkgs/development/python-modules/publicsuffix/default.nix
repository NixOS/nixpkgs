{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  publicsuffix-list,
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

    rm publicsuffix/public_suffix_list.dat
    ln -s ${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat publicsuffix/public_suffix_list.dat
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "publicsuffix" ];

  meta = {
    description = "Allows to get the public suffix of a domain name";
    homepage = "https://pypi.python.org/pypi/publicsuffix/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
