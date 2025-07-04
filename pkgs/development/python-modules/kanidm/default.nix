{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build
  poetry-core,

  # propagates
  aiohttp,
  authlib,
  pydantic,
  toml,

  # tests
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
}:

let
  pname = "kanidm";
  version = "1.0.0-2024-04-22";
in
buildPythonPackage rec {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "kanidm";
    repo = "kanidm";
    rev = "a0f743d8c8e7a6b6b0775e64774fc5175464cab6";
    hash = "sha256-W2v3/osDrjRQqz2DqoG90SGcu4K6G2ypMTfE6Xq5qNI=";
  };

  sourceRoot = "${src.name}/pykanidm";

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    authlib
    pydantic
    toml
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "-m 'not network'" ];

  pythonImportsCheck = [ "kanidm" ];

  meta = with lib; {
    description = "Kanidm client library";
    homepage = "https://github.com/kanidm/kanidm/tree/master/pykanidm";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      arianvp
      hexa
    ];
  };
}
