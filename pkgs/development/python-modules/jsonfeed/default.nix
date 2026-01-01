{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "jsonfeed";
  version = "0.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

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

<<<<<<< HEAD
  meta = {
    description = "Module to process json feed";
    homepage = "https://pypi.org/project/jsonfeed/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module to process json feed";
    homepage = "https://pypi.org/project/jsonfeed/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
