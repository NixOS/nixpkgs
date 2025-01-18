{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "onetimepad";
  version = "1.4";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1eaade76d8036e1cb79e944b75874bfe5ee4046a571c0724564e1721565c73fd";
  };

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "onetimepad" ];

  meta = with lib; {
    description = "Hacky implementation of one-time pad";
    mainProgram = "onetimepad";
    homepage = "https://jailuthra.in/onetimepad";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
