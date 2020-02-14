{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-logstash";
  version = "0.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13763yx0k655y0c8gxv7jj6cqp45zypx2fmnc56jnn9zz1fkx50h";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Python logging handler for Logstash";
    homepage = https://github.com/vklochan/python-logstash;
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.mit;
  };
}
