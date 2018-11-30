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
  version = "3.0.0";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ebe79cf80ad64cb78c880efc7f30ac664e18b80dfd18ee201bf8685cf029628";
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
