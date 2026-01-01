{
  lib,
  anyio,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  hatchling,
  hatch-fancy-pypi-readme,
  h11,
  h2,
<<<<<<< HEAD
=======
  pproxy,
  pytest-asyncio,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytest-httpbin,
  pytest-trio,
  pytestCheckHook,
  pythonOlder,
  socksio,
  trio,
  # for passthru.tests
  httpx,
  httpx-socks,
  respx,
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "1.0.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "httpcore";
    tag = version;
    hash = "sha256-YtAbx0iXN7u8pMBXQBUydvAH6ilH+veklvxSh5EVFXo=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    certifi
    h11
  ];

  optional-dependencies = {
    asyncio = [ anyio ];
    http2 = [ h2 ];
    socks = [ socksio ];
    trio = [ trio ];
  };

  nativeCheckInputs = [
<<<<<<< HEAD
=======
    pproxy
    pytest-asyncio
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pytest-httpbin
    pytest-trio
    pytestCheckHook
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "httpcore" ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit httpx httpx-socks respx;
  };

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/encode/httpcore/blob/${version}/CHANGELOG.md";
    description = "Minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ris ];
=======
  meta = with lib; {
    changelog = "https://github.com/encode/httpcore/blob/${version}/CHANGELOG.md";
    description = "Minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
