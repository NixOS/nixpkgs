{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, freezegun
}:

buildPythonPackage rec {
  pname = "cached-property";
  version = "1.4.0";

  # conftest.py is missing in PyPI tarball
  # https://github.com/pydanny/cached-property/pull/87
  src = fetchFromGitHub {
    owner = "pydanny";
    repo = pname;
    rev = version;
    sha256 = "0w7709grs4yqhfbnn7lva2fgyphvh43xcfqhi95lhh8sjad3xwkw";
  };

  checkInputs = [ pytest freezegun ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "A decorator for caching properties in classes";
    homepage = https://github.com/pydanny/cached-property;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ericsagnes ];
  };
}
