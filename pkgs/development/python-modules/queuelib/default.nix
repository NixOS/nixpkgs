{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "queuelib";
  version = "1.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KFUWIJbPAjBRCJCzVDeeocD/GdEF0xR9NJ0kM7siKwg=";
  };

  buildInputs = [ pytest ];

  meta = with lib; {
    description = "Collection of persistent (disk-based) queues for Python";
    homepage = "https://github.com/scrapy/queuelib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
