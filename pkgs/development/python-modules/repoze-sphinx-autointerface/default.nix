{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytestCheckHook
, zope-interface
, zope-testrunner
, sphinx
}:

buildPythonPackage rec {
  pname = "repoze-sphinx-autointerface";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "repoze.sphinx.autointerface";
    inherit version;
    hash = "sha256-SGvxQjpGlrkVPkiM750ybElv/Bbd6xSwyYh7RsYOKKE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    zope-interface
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    zope-testrunner
  ];

  pythonImportsCheck = [
    "repoze.sphinx.autointerface"
  ];

  pythonNamespaces = [
    "repoze"
    "repoze.sphinx"
  ];

  meta = with lib; {
    homepage = "https://github.com/repoze/repoze.sphinx.autointerface";
    description = "Auto-generate Sphinx API docs from Zope interfaces";
    changelog = "https://github.com/repoze/repoze.sphinx.autointerface/blob/${version}/CHANGES.rst";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
    # https://github.com/repoze/repoze.sphinx.autointerface/issues/21
    broken = versionAtLeast sphinx.version "7.2";
  };
}
