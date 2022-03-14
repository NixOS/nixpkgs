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
  version = "5.1.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kNGTb6mA2XBaljYvpOWaKFEks3NigsiPgmdIgSMKTiU=";
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
