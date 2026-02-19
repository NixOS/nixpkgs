{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "jsonfeed";
  version = "0.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Etfi59oOCrLHavLRMQo3HASFnydrBnsyEtGUgcsv1aQ=";
  };

  postPatch = ''
    # Mixing of dev and runtime requirements
    substituteInPlace setup.py \
      --replace-fail "install_requires=install_requires," "install_requires=[],"
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Module has no tests, only a placeholder
  doCheck = false;

  pythonImportsCheck = [ "jsonfeed" ];

  meta = {
    description = "Module to process json feed";
    homepage = "https://pypi.org/project/jsonfeed/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
