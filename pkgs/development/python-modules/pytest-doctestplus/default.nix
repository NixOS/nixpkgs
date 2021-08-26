{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, six
, pytest
, pytestCheckHook
, numpy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "0.10.1";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e9e0912c206c53cd6ee996265aa99d5c99c9334e37d025ce6114bc0416ffc14";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];
  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    six
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Pytest plugin with advanced doctest features";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
