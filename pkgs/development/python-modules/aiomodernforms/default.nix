{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, backoff
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiomodernforms";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "wonderslug";
    repo = "aiomodernforms";
    rev = "v${version}";
    sha256 = "1yrs5q4ggasbjn6z8x04yamn2wra702i09iqyzj9aqq31bc9jnd1";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "packaging" ""
  '';

  propagatedBuildInputs = [
    aiohttp
    backoff
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiomodernforms" ];

  meta = with lib; {
    description = "Asynchronous Python client for Modern Forms fans";
    homepage = "https://github.com/wonderslug/aiomodernforms";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
