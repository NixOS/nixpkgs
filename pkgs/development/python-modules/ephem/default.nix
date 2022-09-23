{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, pytest
}:

buildPythonPackage rec {
  pname = "ephem";
  version = "4.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f6GGhZgbpSjt1QQFKp1SEqCapb8VwRpzTtxqhuiotWo=";
  };

  checkInputs = [
    glibcLocales
    pytest
  ];

  # JPLTest uses assets not distributed in package
  checkPhase = ''
    LC_ALL="en_US.UTF-8" pytest --pyargs ephem.tests -k "not JPLTest"
  '';

  pythonImportsCheck = [
    "ephem"
  ];

  meta = with lib; {
    description = "Compute positions of the planets and stars";
    homepage = "https://github.com/brandon-rhodes/pyephem";
    license = licenses.mit;
    maintainers = with maintainers; [ chrisrosset ];
  };
}
