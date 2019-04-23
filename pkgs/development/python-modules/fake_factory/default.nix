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
  version = "9999.9.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5bd18deb22ad8cb4402513c025877bc6b50de58902d686b6b21ba8981dce260";
  };

  propagatedBuildInputs = [ six dateutil ipaddress mock ];

  # fake-factory is depreciated and single test will always fail
  doCheck = false;

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
