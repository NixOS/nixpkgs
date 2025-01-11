{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "async-cache";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iamsinghrajat";
    repo = "async-cache";
    rev = "9925f07920e6b585dc6345f49b7f477b3e1b8c2c"; # doesn't tag releases :(
    hash = "sha256-AVSdtWPs1c8AE5PNOq+BdXzBXkI0aeFVzxxPl/ATyU0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "cache" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Caching solution for asyncio";
    homepage = "https://github.com/iamsinghrajat/async-cache";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lukegb ];
  };
}
