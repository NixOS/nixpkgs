{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, six
, pytest
, python
}:

buildPythonPackage rec {
  pname = "drms";
  version = "0.5.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab3ec6d072b1980f77dadf3b2cb0fe56c648eaf927ea381f606b4db66d4cbff2";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    six
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    ${python.interpreter} -m drms.tests
  '';

  meta = with lib; {
    description = "Access HMI, AIA and MDI data with Python";
    homepage = "https://github.com/sunpy/drms";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
