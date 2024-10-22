{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
  pytestCheckHook,
  six,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mohawk";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0qDjqxCiCcx56V4o8t1UvUpz/RmY/+J7e6D5Yra+lyM=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/kumar303/mohawk/pull/59
      name = "nose-to-pytest.patch";
      url = "https://github.com/kumar303/mohawk/compare/b7899166880e890f01cf2531b5686094ba08df8f...66157c7efbf6b0d18c30a9ffe5dfd84bef27bd3a.patch";
      hash = "sha256-w3sP5XeBqOwoPGsWzYET4djYwuKPaS4OOlC3HBPD0NI=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "mohawk/tests.py" ];

  meta = {
    description = "Python library for Hawk HTTP authorization";
    homepage = "https://github.com/kumar303/mohawk";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
