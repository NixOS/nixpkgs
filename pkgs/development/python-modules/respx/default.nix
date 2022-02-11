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
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = pname;
    rev = version;
    sha256 = "134h9526md242p7ql0cpknqvkpd3fhxk2vridkvswg91f532w180";
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
