{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "colored";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BP9NTdUUJ0/juZohu1L7lvJojAHpP7p77zciHny1bOA=";
  };

  # No proper test suite
  doCheck = false;

  meta = with lib; {
    homepage = "https://gitlab.com/dslackw/colored";
    description = "Simple library for color and formatting to terminal";
    license = licenses.mit;
  };

}
