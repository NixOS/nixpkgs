{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pycategories";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vXDstelOdlnlZOoVPwx2cykdw3xSbCRoAPwI1sU3gJk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
    substituteInPlace setup.cfg \
      --replace "--cov-report term --cov=categories" ""
  '';

  # Is private because the author states it's unmaintained
  # and shouldn't be used in production code
  propagatedBuildInputs = [ (callPackage ./infix.nix { }) ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Implementation of some concepts from category theory";
    homepage = "https://gitlab.com/danielhones/pycategories";
    changelog = "https://gitlab.com/danielhones/pycategories/-/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dmvianna ];
  };
}
