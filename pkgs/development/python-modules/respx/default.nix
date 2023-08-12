{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = pname;
    rev = version;
    hash = "sha256-Qs3+NWMKiAFlKTTosdyHOxWRPKFlYQD20+MKiKR371U=";
  };

  patches = [
    (fetchpatch {
      name = "httpx-0.24-test-compatibility.patch";
      url = "https://github.com/lundberg/respx/commit/b014780bde8e82a65fc6bb02d62b89747189565c.patch";
      hash = "sha256-wz9YYUtdptZw67ddnzUCet2iTozKaW0jrTIS62I/HXo=";
    })
  ];

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

  pythonImportsCheck = [ "respx" ];

  meta = with lib; {
    description = "Python library for mocking HTTPX";
    homepage = "https://lundberg.github.io/respx/";
    changelog = "https://github.com/lundberg/respx/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
