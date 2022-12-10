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
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = pname;
    rev = version;
    sha256 = "sha256-xb5jb+l6wA1v/r2yGUB6IuUVXIaTc+3O/w5xn/+A74o=";
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
    changelog = "https://github.com/lundberg/respx/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
