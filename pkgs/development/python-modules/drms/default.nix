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
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95cac0e14532893a44eeab8e329ddb76150e6848153d8cb1e4e08ba55569e6af";
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
    homepage = https://github.com/sunpy/drms;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
