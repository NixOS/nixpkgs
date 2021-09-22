{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "parts";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Xtcu/0ZO+6L7RiVfq/Jog4f7LOtZo4QUD1qi7UdPO7g=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "parts" ];

  meta = with lib; {
    description = "Python library for common list functions related to partitioning lists";
    homepage = "https://github.com/lapets/parts";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
