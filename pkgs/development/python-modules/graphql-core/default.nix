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
  version = "3.2.5";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphql-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-xZOiQOFWnImDXuvHP9V6BDjIZwlwHSxN/os+UYV4A0M=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
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

  pythonImportsCheck = [ "graphql" ];

  meta = with lib; {
    changelog = "https://github.com/graphql-python/graphql-core/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
