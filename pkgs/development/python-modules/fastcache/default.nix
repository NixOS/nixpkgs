{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "fastcache";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0avqpswfmw5b08xx3ib6zchc5bis390fn1v74vg7nnrkf1pb3qbd";
  };

  nativeCheckInputs = [ pytest ];

  meta = {
    description = "C implementation of Python3 lru_cache for Python 2 and 3";
    homepage = "https://github.com/pbrady/fastcache";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bhipple ];
  };
}
