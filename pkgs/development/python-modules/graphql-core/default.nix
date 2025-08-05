{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-benchmark,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.2.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphql-core";
    tag = "v${version}";
    hash = "sha256-RkVyoTSVmtKhs42IK+oOrOL4uBs3As3N5KY0Sz1VaDQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry_core>=1,<2" "poetry-core" \
      --replace-fail ', "setuptools>=59,<70"' ""
  '';

  build-system = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "graphql" ];

  meta = with lib; {
    changelog = "https://github.com/graphql-python/graphql-core/releases/tag/${src.tag}";
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
