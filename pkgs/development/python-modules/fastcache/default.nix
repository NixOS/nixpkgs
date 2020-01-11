{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "fastcache";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0avqpswfmw5b08xx3ib6zchc5bis390fn1v74vg7nnrkf1pb3qbd";
  };

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "C implementation of Python3 lru_cache for Python 2 and 3";
    homepage = https://github.com/pbrady/fastcache;
    license = licenses.mit;
    maintainers = [ maintainers.bhipple ];
  };
}
