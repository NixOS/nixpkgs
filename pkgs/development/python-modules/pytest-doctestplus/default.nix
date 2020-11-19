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
  version = "0.8.0";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb083925a17ce636f33997c275f61123e63372c1db11fefac1e991ed25a4ca37";
  };

  propagatedBuildInputs = [
    six
    numpy
    pytest
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
