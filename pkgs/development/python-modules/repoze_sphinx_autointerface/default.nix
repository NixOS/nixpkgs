{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, zope_interface
, zope_testrunner
, sphinx
}:

buildPythonPackage rec {
  pname = "repoze.sphinx.autointerface";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SGvxQjpGlrkVPkiM750ybElv/Bbd6xSwyYh7RsYOKKE=";
  };

  propagatedBuildInputs = [
    zope_interface
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    zope_testrunner
  ];

  meta = with lib; {
    homepage = "https://github.com/repoze/repoze.sphinx.autointerface";
    description = "Auto-generate Sphinx API docs from Zope interfaces";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
