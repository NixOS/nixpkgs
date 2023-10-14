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
  version = "0.20.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = pname;
    rev = version;
    hash = "sha256-OiBKNK8V9WNQDe29Q5+E/jjBWD0qFcYUzhYUWA+7oFc=";
  };

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/lundberg/respx/blob/${version}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
