{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "queuelib";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "631d067c9be57e395c382d680d3653ca1452cd29e8da25c5e8d94b5c0c528c31";
  };

  buildInputs = [ pytest ];

  meta = with lib; {
    description = "A collection of persistent (disk-based) queues for Python";
    homepage = "https://github.com/scrapy/queuelib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett ];
  };

}
