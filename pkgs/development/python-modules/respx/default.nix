{ lib
, buildPythonPackage
, fetchFromGitHub
, httpcore
, httpx
, flask
, pytest-asyncio
, pytestCheckHook
, starlette
, trio
}:

buildPythonPackage rec {
  pname = "respx";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = pname;
    rev = version;
    sha256 = "sha256-xiAt42kc1+rro99KMwzYKi3XC+wxYVqOY11tM+M/uV8=";
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

  pythonImportsCheck = [ "respx" ];

  meta = with lib; {
    description = "Python library for mocking HTTPX";
    homepage = "https://lundberg.github.io/respx/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
