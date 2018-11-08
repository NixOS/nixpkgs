{ stdenv, fetchPypi, buildPythonPackage, python }:

buildPythonPackage rec {
  pname = "authres";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mcllhrwr23hwa2jn3m15k29ks1205ymwafjzchh8ma664hnzv6v";
  };

  checkPhase = ''
    # run doctests
    ${python.interpreter} -m authres
  '';

  meta = with stdenv.lib; {
    description = "Email Authentication-Results Headers generation and parsing for Python/Python3";
    longDescription = ''
      Python module that implements various internet RFC's: 5451/7001/7601
      Authentication-Results Headers generation and parsing for
      Python/Python3.
    '';
    homepage = https://launchpad.net/authentication-results-python;
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
