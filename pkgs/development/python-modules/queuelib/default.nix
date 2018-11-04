{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "queuelib";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42b413295551bdc24ed9376c1a2cd7d0b1b0fa4746b77b27ca2b797a276a1a17";
  };

  buildInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "A collection of persistent (disk-based) queues for Python";
    homepage = "https://github.com/scrapy/queuelib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett ];
  };

}
