{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, glibcLocales
, pytest
}:

buildPythonPackage rec {
  pname = "ephem";
  version = "4.0.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0D3nPr9qkWgdWX61tdQ7z28MZ+KSu6L5qXRzS08VdX4=";
  };

  checkInputs = [
    glibcLocales
    pytest
  ];

  # JPLTest uses assets not distributed in package
  checkPhase = ''
    LC_ALL="en_US.UTF-8" pytest --pyargs ephem.tests -k "not JPLTest"
  '';

  pythonImportsCheck = [ "ephem" ];

  meta = with lib; {
    description = "Compute positions of the planets and stars";
    homepage = "https://github.com/brandon-rhodes/pyephem";
    license = licenses.mit;
    maintainers = with maintainers; [ chrisrosset ];
  };
}
