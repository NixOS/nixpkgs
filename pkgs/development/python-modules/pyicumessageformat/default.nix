{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyicumessageformat";
  version = "1.0.0";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s+l8DtEMKxA/DzpwGqZSlwDqCrZuDzsj3I5K7hgfyEA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyicumessageformat" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Unopinionated Python3 parser for ICU MessageFormat";
    homepage = "https://github.com/SirStendec/pyicumessageformat/";
    # Based on master, as upstream doesn't tag their releases on GitHub anymore
    changelog = "https://github.com/SirStendec/pyicumessageformat/blob/master/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}
