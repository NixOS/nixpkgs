{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-logstash";
  version = "0.4.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0E4c4R7MEH5KTzuAf8V9loEelkpVQIGzu7RHMvdO9fk=";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Python logging handler for Logstash";
    homepage = "https://github.com/vklochan/python-logstash";
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.mit;
  };
}
