{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "intbitset";
<<<<<<< HEAD
  version = "4.1.0";
=======
  version = "4.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-cxRf8F5CJ8dlhf+FUGOLagg80TABC3gQRdga9Y97aSA=";
=======
    hash = "sha256-wUHtqhwXuRwph1N+Jp2VWra9w5Zq89624eDSDtvQndI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "intbitset" ];

  meta = {
    description = "C-based extension implementing fast integer bit sets";
    homepage = "https://github.com/inveniosoftware/intbitset";
    changelog = "https://github.com/inveniosoftware-contrib/intbitset/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
