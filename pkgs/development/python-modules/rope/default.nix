{ lib
, buildPythonPackage
, fetchPypi
, pytoolconfig
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "rope";
  version = "1.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kxrqFUNlVWp9qsAcvOzgycEYdVv/98ZaskK2lYUWfso=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pytoolconfig
  ] ++ pytoolconfig.optional-dependencies.global;

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_search_submodule"
    "test_get_package_source_pytest"
    "test_get_modname_folder"
  ];

  meta = with lib; {
    description = "Python refactoring library";
    homepage = "https://github.com/python-rope/rope";
    maintainers = with maintainers; [ goibhniu ];
    license = licenses.gpl3Plus;
  };
}
