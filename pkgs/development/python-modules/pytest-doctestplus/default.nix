{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8872b9c236924af20c39c2813d7f1bde50a1edca7c4aba5a8bfbae3a32360e87";
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
