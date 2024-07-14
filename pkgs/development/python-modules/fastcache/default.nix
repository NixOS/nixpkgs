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
    hash = "sha256-beGxbnAzW3veJmcH60AaOq7CIPtmxdE7Aqvw6ri+eCs=";
  };

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "C implementation of Python3 lru_cache for Python 2 and 3";
    homepage = "https://github.com/pbrady/fastcache";
    license = licenses.mit;
    maintainers = [ maintainers.bhipple ];
  };
}
