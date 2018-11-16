{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, freezegun
}:

buildPythonPackage rec {
  pname = "cached-property";
  version = "1.4.2";

  # conftest.py is missing in PyPI tarball
  src = fetchFromGitHub {
    owner = "pydanny";
    repo = pname;
    rev = version;
    sha256 = "0gjmgfilhljkx2b60cjikwh55jg2jwxhwi8hgkrzdnzk465ywhrw";
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
