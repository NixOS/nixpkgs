{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, six
, astropy
, pytestCheckHook
, pytest-doctestplus
}:

buildPythonPackage rec {
  pname = "drms";
  version = "0.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "74efb903f42647ea536de0c5aea4f9a81efe027c95055ec4e72ef62479a04c89";
  };

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

  meta = with lib; {
    description = "Access HMI, AIA and MDI data with Python";
    homepage = "https://github.com/sunpy/drms";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
