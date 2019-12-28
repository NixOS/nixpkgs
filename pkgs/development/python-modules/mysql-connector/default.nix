{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "mysql-connector";
  version = "2.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cnzxy2r4648p8wxfjlc8lswnlm84ay1ykr6wcyj8jd0ab7fccqp";
  };

  doCheck = false;

  meta = {
    description = "MySQL driver written in Python";
    homepage = "https://dev.mysql.com/doc/connector-python/en/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
