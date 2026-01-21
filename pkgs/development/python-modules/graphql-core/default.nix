{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-benchmark,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphql-core";
    tag = "v${version}";
    hash = "sha256-ag8yFf6254dX2xNZMKtVBW5QtI5JOZjzgcZveuoeAss=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools>=59,<76"' ""
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

  meta = {
    changelog = "https://github.com/graphql-python/graphql-core/releases/tag/${src.tag}";
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
