{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "colored";
  version = "1.4.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BP9NTdUUJ0/juZohu1L7lvJojAHpP7p77zciHny1bOA=";
  };

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "colored"
  ];

  meta = with lib; {
    description = "Simple library for color and formatting to terminal";
    homepage = "https://gitlab.com/dslackw/colored";
    changelog = "https://gitlab.com/dslackw/colored/-/raw/${version}/CHANGES.md";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
