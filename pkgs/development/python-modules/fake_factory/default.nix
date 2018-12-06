{ stdenv
, buildPythonPackage
, fetchPypi
, python
, six
, dateutil
, ipaddress
, mock
}:

buildPythonPackage rec {
  pname = "fake-factory";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09sgk0kylsshs64a1xsz3qr187sbnqrbf4z8k3dgsy32lsgyffv2";
  };

  propagatedBuildInputs = [ six dateutil ipaddress mock ];
  checkPhase = ''
    ${python.interpreter} -m unittest faker.tests
  '';

  meta = with stdenv.lib; {
    description = "A Python package that generates fake data for you";
    homepage    = https://pypi.python.org/pypi/fake-factory;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
