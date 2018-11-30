{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "fastcache";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rl489zfbm2x67n7i6r7r4nhrhwk6yz3yc7x9y2rky8p95vhaw46";
  };

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "C implementation of Python3 lru_cache for Python 2 and 3";
    homepage = https://github.com/pbrady/fastcache;
    license = licenses.mit;
    maintainers = [ maintainers.bhipple ];
  };
}
