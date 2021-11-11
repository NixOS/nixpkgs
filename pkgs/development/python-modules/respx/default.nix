{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, httpcore
, httpx
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, starlette
, trio
}:

buildPythonPackage rec {
  pname = "respx";
  version = "0.18.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = pname;
    rev = version;
    sha256 = "sha256-JgXnR2WpVbENFePLK2W8z9RkEwsGxqs08pO2eIpPpZ0=";
  };

  propagatedBuildInputs = [
    httpx
  ];

  checkInputs = [
    httpcore
    httpx
    flask
    pytest-asyncio
    pytestCheckHook
    starlette
    trio
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  disabledTests = [
    "test_pass_through"
  ];

  pythonImportsCheck = [
    "respx"
  ];

  meta = with lib; {
    description = "Python library for mocking HTTPX";
    homepage = "https://lundberg.github.io/respx/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
