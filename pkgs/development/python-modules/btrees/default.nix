{
  lib,
  fetchPypi,
  buildPythonPackage,
  persistent,
  zope-interface,
  transaction,
  zope-testrunner,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "btrees";
<<<<<<< HEAD
  version = "6.3";
=======
  version = "6.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Fga9/6erKMaACYRUC2le7oSPbhWwFF2Fj/SwxiZOjtI=";
=======
    hash = "sha256-SnxwN2aEfrD6tYrpudacyAWIy/1uNFcrur1FU+B5/is=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    persistent
    zope-interface
  ];

  nativeCheckInputs = [
    transaction
    zope-testrunner
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m zope.testrunner --test-path=src --auto-color --auto-progress

    runHook postCheck
  '';

  pythonImportsCheck = [
    "BTrees.OOBTree"
    "BTrees.IOBTree"
    "BTrees.IIBTree"
    "BTrees.IFBTree"
  ];

<<<<<<< HEAD
  meta = {
    description = "Scalable persistent components";
    homepage = "http://packages.python.org/BTrees";
    changelog = "https://github.com/zopefoundation/BTrees/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
=======
  meta = with lib; {
    description = "Scalable persistent components";
    homepage = "http://packages.python.org/BTrees";
    changelog = "https://github.com/zopefoundation/BTrees/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
