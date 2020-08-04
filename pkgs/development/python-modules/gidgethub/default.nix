{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytestrunner
, pytest
, pytest-asyncio
, twisted
, treq
, tornado
, aiohttp
, uritemplate
, pyjwt
}:

buildPythonPackage rec {
  pname = "gidgethub";
  version = "4.1.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfabfa696d422ee91eaf1e3f01ea75e576721233cc3ea8badc7d86c30061df8e";
  };

  nativeBuildInputs = [ setuptools pytestrunner ];
  checkInputs = [ pytest pytest-asyncio twisted treq tornado aiohttp ];
  propagatedBuildInputs = [
    uritemplate
    pyjwt
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "extras_require=extras_require," "extras_require=None,"
  '';

  # requires network (reqests github.com)
  doCheck = false;

  meta = with lib; {
    description = "An async GitHub API library";
    homepage = "https://github.com/brettcannon/gidgethub";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
