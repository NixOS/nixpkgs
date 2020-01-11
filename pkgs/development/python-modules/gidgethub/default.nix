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
  version = "3.2.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f4b69063a256994d38243cc0eba4e1453017b5b8b04a173216d02d47ffc3989";
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
