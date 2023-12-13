{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "queuelib";
  version = "1.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b207267f2642a8699a1f806045c56eb7ad1a85a10c0e249884580d139c2fcd2";
  };

  buildInputs = [ pytest ];

  meta = with lib; {
    description = "A collection of persistent (disk-based) queues for Python";
    homepage = "https://github.com/scrapy/queuelib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
