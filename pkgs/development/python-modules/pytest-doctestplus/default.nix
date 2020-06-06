{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "0.7.0";

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

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pytest plugin with advanced doctest features";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
