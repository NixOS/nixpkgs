{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, freezegun
}:

buildPythonPackage rec {
  pname = "cached-property";
  version = "1.5.1";

  # conftest.py is missing in PyPI tarball
  src = fetchFromGitHub {
    owner = "pydanny";
    repo = pname;
    rev = version;
    sha256 = "0xh0pwmiikx0il9nnfyf034ydmlw6992s0d209agd9j5d3s2k5q6";
  };

  checkInputs = [ pytest freezegun ];

  # https://github.com/pydanny/cached-property/issues/131
  checkPhase = ''
    py.test -k "not test_threads_ttl_expiry"
  '';

  meta = {
    description = "A decorator for caching properties in classes";
    homepage = https://github.com/pydanny/cached-property;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ericsagnes ];
  };
}
