{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, six
, astropy
, pytestCheckHook
, pytest-doctestplus
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "drms";
  version = "0.6.3";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-crPVo7ALErZWvNcsaJ/BuBa0VkfCsZ+C929x4kEZHKw=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    six
  ];

  nativeCheckInputs = [
    astropy
    pytestCheckHook
    pytest-doctestplus
  ];

  disabledTests = [
    "test_query_hexadecimal_strings"
  ];

  disabledTestPaths = [
    "docs/tutorial.rst"
  ];

  pythonImportsCheck = [ "drms" ];

  meta = with lib; {
    description = "Access HMI, AIA and MDI data with Python";
    homepage = "https://github.com/sunpy/drms";
    license = licenses.bsd2;
    maintainers = with maintainers; [ costrouc ];
  };
}
