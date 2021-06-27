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
  version = "0.9.0";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "6fe747418461d7b202824a3486ba8f4fa17a9bd0b1eddc743ba1d6d87f03391a";
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
