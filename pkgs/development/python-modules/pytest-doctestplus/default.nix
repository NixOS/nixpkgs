{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, six
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "0.9.0";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "6fe747418461d7b202824a3486ba8f4fa17a9bd0b1eddc743ba1d6d87f03391a";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    six
    numpy
  ];

  checkInputs = [
    pytest
  ];

  # check_distribution incorrectly pulls pytest version
  checkPhase = ''
    pytest -k 'not check_distribution'
  '';

  meta = with lib; {
    description = "Pytest plugin with advanced doctest features";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
