{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "queuelib";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6829918157ed433fafa87b0bb1e93e3e63c885270166db5884a02c34c86f914";
  };

  buildInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "A collection of persistent (disk-based) queues for Python";
    homepage = "https://github.com/scrapy/queuelib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett ];
  };

}
