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
}:

buildPythonPackage rec {
  pname = "gidgethub";
  version = "3.1.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52119435ba73ddd5e697dae7bec8b93a048bc738720b81691ebd4b4d81d2d762";
  };

  nativeBuildInputs = [ setuptools pytestrunner ];
  checkInputs = [ pytest pytest-asyncio twisted treq tornado aiohttp ];
  propagatedBuildInputs = [ uritemplate ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "extras_require=extras_require," "extras_require=None,"
  '';

  # requires network (reqests github.com)
  doCheck = false;

  meta = with lib; {
    description = "An async GitHub API library";
    homepage = https://github.com/brettcannon/gidgethub;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
