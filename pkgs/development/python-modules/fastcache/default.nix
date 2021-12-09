{ lib, buildPythonPackage, fetchFromGitHub, pytest }:

buildPythonPackage rec {
  pname = "fastcache";
  version = "1.1.0";

  src = fetchFromGitHub {
     owner = "pbrady";
     repo = "fastcache";
     rev = "v1.1.0";
     sha256 = "097q19wnx7a2c0vjaxr08xf5vhm1z1a2lza05ccsfgrn189681xp";
  };

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "C implementation of Python3 lru_cache for Python 2 and 3";
    homepage = "https://github.com/pbrady/fastcache";
    license = licenses.mit;
    maintainers = [ maintainers.bhipple ];
  };
}
