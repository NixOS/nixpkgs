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
  version = "0.6.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Id8rPK8qq71gHn5DKnEi7Lp081GFbcFtGU+v89Vlt9o=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    six
  ];

  checkInputs = [
    astropy
    pytestCheckHook
    pytest-doctestplus
  ];

  pythonImportsCheck = [ "drms" ];

  meta = with lib; {
    description = "Access HMI, AIA and MDI data with Python";
    homepage = "https://github.com/sunpy/drms";
    license = licenses.bsd2;
    maintainers = with maintainers; [ costrouc ];
  };
}
