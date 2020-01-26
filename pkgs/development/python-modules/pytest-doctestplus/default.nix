{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41386187b9261cd59a3ffe4cf9df58d517288a1d3f11d96749b39b4e38b0a02c";
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
