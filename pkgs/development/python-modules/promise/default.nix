{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "promise";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "syrusakbary";
    repo = "promise";
    tag = "v${version}";
    hash = "sha256-5s6GMANSO4UpLOP/HAQxuNFSBSjPgvJCB9R1dOoKuJ4=";
  };

  patches = [
    # Convert @asyncio.coroutine to async def, https://github.com/syrusakbary/promise/pull/99
    (fetchpatch {
      name = "use-async-def.patch";
      url = "https://github.com/syrusakbary/promise/commit/3cde549d30b38dcff81b308e18c7f61783003791.patch";
      hash = "sha256-XCbTo6RCv75nNrpbK3TFdV0h7tBJ0QK+WOAR8S8w9as=";
    })
  ];

  postPatch = ''
    substituteInPlace tests/test_extra.py \
      --replace "assert_exc.traceback[-1].path.strpath" "str(assert_exc.traceback[-1].path)"
  '';

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Failed: async def functions are not natively supported
    "test_issue_9_safe"
  ];

  disabledTestPaths = [ "tests/test_benchmark.py" ];

  pythonImportsCheck = [ "promise" ];

  meta = with lib; {
    description = "Ultra-performant Promise implementation in Python";
    homepage = "https://github.com/syrusakbary/promise";
    changelog = "https://github.com/syrusakbary/promise/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
