{ fetchPypi
, lib
, buildPythonPackage
, setuptools
, numpy
, wheel
,
}:
buildPythonPackage rec {
  pname = "gekko";
  version = "1.0.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MXoxrejg+QJgajFv8DgZw44NeJuTHNBBK/lsWgmymJY=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "gekko" ];

  propagatedBuildInputs = [
    numpy
  ];

  meta = with lib; {
    homepage = "https://github.com/BYU-PRISM/GEKKO";
    description = "A Python package for machine learning and optimization";
    license = licenses.mit;
    maintainers = with maintainers; [ ayes-web ];
  };
}
