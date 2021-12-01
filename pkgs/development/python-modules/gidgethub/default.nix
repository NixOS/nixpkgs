{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytest-runner
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
  version = "5.0.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3efbd6998600254ec7a2869318bd3ffde38edc3a0d37be0c14bc46b45947b682";
  };

  nativeBuildInputs = [ setuptools pytest-runner ];
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
