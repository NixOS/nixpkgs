{
  beartype,
  buildPythonPackage,
  fetchFromGitHub,
  inline-snapshot,
  lib,
  pytestCheckHook,
  pytest-xdist,
  typing-extensions,
  uv-build,
}:

buildPythonPackage rec {
  pname = "py-key-value-shared";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strawgate";
    repo = "py-key-value";
    tag = version;
    hash = "sha256-4ji+GzJTv1QnC5n/OaL9vR65j8BQmJsVGGnjjuulDiU=";
  };

  sourceRoot = "${src.name}/key-value/key-value-shared";

  build-system = [ uv-build ];

  dependencies = [
    beartype
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "uv_build>=0.8.2,<0.9.0" "uv_build"
  '';

  nativeCheckInputs = [
    inline-snapshot
    pytestCheckHook
    pytest-xdist
  ];

  disabledTestPaths = [
    # Missing key_value.sharedtest module
    "tests/utils/test_managed_entry.py"
  ];

  pythonImportsCheck = [ "key_value.shared" ];

  meta = {
    description = "Shared module for py-key-value packages";
    homepage = "https://strawgate.com/py-key-value/";
    changelog = "https://github.com/strawgate/py-key-value/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
