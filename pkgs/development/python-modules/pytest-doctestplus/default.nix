{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e641bc720661c08ec3afe44a7951660cdff5e187259c433aa66e9ec2d5ccea1";
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
    homepage = https://astropy.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
