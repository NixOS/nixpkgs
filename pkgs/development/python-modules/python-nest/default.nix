{ buildPythonPackage, fetchPypi, lib, python, python-dateutil, requests
, six, sseclient-py }:

buildPythonPackage rec {
  pname = "python-nest";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12iyypbl92ybh8w1bf4z0c2g0sb9id2c07c89vzvnlxgjylw3wbi";
  };

  propagatedBuildInputs = [ python-dateutil requests six sseclient-py ];
  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "nest" ];

  meta = with lib; {
    description =
      "Python API and command line tool for talking to the Nest™ Thermostat";
    homepage = "https://github.com/jkoelker/python-nest";
    license = licenses.cc-by-nc-sa-40;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
