{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytest
, pytest-cov
, pytestCheckHook
, numpy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-astropy-header";
  version = "0.2.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77891101c94b75a8ca305453b879b318ab6001b370df02be2c0b6d1bb322db10";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  meta = with lib; {
    description = "Plugin to add diagnostic information to the header of the test output";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
