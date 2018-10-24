{ stdenv
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
  version = "2.5.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d37fdfd149bc0efa21d3899c737d9b5c7ff6348a9b3f03bf3aa0e9f8ca345483";
  };

  buildInputs = [ setuptools pytestrunner ];
  checkInputs = [ pytest pytest-asyncio twisted treq tornado aiohttp ];
  propagatedBuildInputs = [ uritemplate ];

  # requires network (reqests github.com)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An async GitHub API library";
    homepage = https://github.com/brettcannon/gidgethub;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
