{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "colored";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7b48b9f40e8a65bbb54813d5d79dd008dc8b8c5638d5bbfd30fc5a82e6def7a";
  };

  # No proper test suite
  doCheck = false;

  meta = with lib; {
    homepage = "https://gitlab.com/dslackw/colored";
    description = "Simple library for color and formatting to terminal";
    license = licenses.mit;
  };

}
