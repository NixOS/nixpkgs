{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "isodate";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TNGqD0PKdvSmxsApKoX0CzXsLkPjFbWfBubTIXGpU+Y=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/gweis/isodate/blob/${version}/CHANGES.txt";
    description = "ISO 8601 date/time parser";
    homepage = "https://github.com/gweis/isodate/";
    license = lib.licenses.bsd0;
=======
  meta = with lib; {
    changelog = "https://github.com/gweis/isodate/blob/${version}/CHANGES.txt";
    description = "ISO 8601 date/time parser";
    homepage = "https://github.com/gweis/isodate/";
    license = licenses.bsd0;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
