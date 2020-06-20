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
  version = "0.7.0";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed440f43e33191f09aed7bbc4f60db3dfb8f295ab33e04c59302af7eda9e29aa";
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
