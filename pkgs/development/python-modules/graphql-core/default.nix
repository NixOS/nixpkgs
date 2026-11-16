{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-describe,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.2.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphql-core";
    tag = "v${version}";
    hash = "sha256-06oxzqUVgmfEQXGmJLgMKw3/gCIMNyyXpwIO4rj7FYc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools>=59,<85"' ""

    # avoid big pytest-benchmark dependency
    substituteInPlace setup.cfg \
      --replace-fail "addopts = --benchmark-disable" ""
  '';

  build-system = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-describe
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/benchmarks"
  ];

  pythonImportsCheck = [ "graphql" ];

  meta = {
    changelog = "https://github.com/graphql-python/graphql-core/releases/tag/${src.tag}";
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirdukkkkk ];
  };
}
