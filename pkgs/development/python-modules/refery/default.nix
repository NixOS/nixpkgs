{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  poetry-core,
  pyyaml,
  colorama,
  junit-xml,
}:

buildPythonPackage rec {
  pname = "refery";
  version = "2.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha512-ju0lqCSg0zcZNqRXDmFX6X1ugBocpmHMBWJApO6Tzhm/tLMQTKy2RpB4C8fkKCEWA2mYX4w1dLdHe68hZixwkQ==";
  };

  propagatedBuildInputs = [
    poetry-core
    pyyaml
    colorama
    junit-xml
  ];

  pythonImportsCheck = [ "refery" ];

  disabled = pythonOlder "3.10";

  # No tests yet
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Functional testing tool";
    homepage = "https://github.com/RostanTabet/refery";
    mainProgram = "refery";
    maintainers = with lib.maintainers; [ rostan-t ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Functional testing tool";
    homepage = "https://github.com/RostanTabet/refery";
    mainProgram = "refery";
    maintainers = with maintainers; [ rostan-t ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
