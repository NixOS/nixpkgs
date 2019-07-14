{ lib
, buildPythonPackage
, fetchPypi
, pytest
, matplotlib
, nose
}:

buildPythonPackage rec {
  pname = "pytest-mpl";
  version = "0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7006e63bf1ca9c50bea3d189c0f862751a16ce40bb373197b218f57af5b837c0";
  };

  propagatedBuildInputs = [
    matplotlib
    nose
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "pytest plugin to help with testing figures output from Matplotlib";
    homepage = https://github.com/matplotlib/pytest-mpl;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
