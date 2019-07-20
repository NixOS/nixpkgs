{ lib
, buildPythonPackage
, fetchPypi
, zetup
, six
, moretools
, pathpy
, pytest
}:

buildPythonPackage rec {
  pname = "modeled";
  version = "0.1.8";

  src = fetchPypi {
    extension = "zip";
    inherit pname version;
    sha256 = "64934c68cfcdb75ed4a1ccadcfd5d2a46bf1b8e8e81dde89ef0f042c401e94f1";
  };

  buildInputs = [
    zetup
  ];

  propagatedBuildInputs = [
    six
    moretools
    pathpy
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest test
  '';

  meta = with lib; {
    description = "Universal data modeling for Python";
    homepage = https://bitbucket.org/userzimmermann/python-modeled;
    license = licenses.lgpl3;
    maintainers = [ maintainers.costrouc ];
  };
}
