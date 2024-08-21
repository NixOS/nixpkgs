{
  lib,
  fetchPypi,
  buildPythonPackage,
  python,
}:

buildPythonPackage rec {
  pname = "authres";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dr5zpqnb54h4f5ax8334l1dcp8j9083d7v4vdi1xqkwmnavklck";
  };

  checkPhase = ''
    # run doctests
    ${python.interpreter} -m authres
  '';

  meta = with lib; {
    description = "Email Authentication-Results Headers generation and parsing for Python/Python3";
    longDescription = ''
      Python module that implements various internet RFC's: 5451/7001/7601
      Authentication-Results Headers generation and parsing for
      Python/Python3.
    '';
    homepage = "https://launchpad.net/authentication-results-python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
