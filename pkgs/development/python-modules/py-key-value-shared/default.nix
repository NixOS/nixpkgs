{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  beartype,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-xdist,
  inline-snapshot,
  py-key-value-shared-test,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-key-value-shared";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strawgate";
    repo = "py-key-value";
    tag = finalAttrs.version;
    hash = "sha256-4ji+GzJTv1QnC5n/OaL9vR65j8BQmJsVGGnjjuulDiU=";
  };

  sourceRoot = "${finalAttrs.src.name}/key-value/key-value-shared";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "uv_build>=0.8.2,<0.9.0" \
        "uv_build"
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    beartype
    typing-extensions
  ];

  pythonImportsCheck = [ "key_value.shared" ];

  nativeCheckInputs = [
    inline-snapshot
    py-key-value-shared-test
    pytest-xdist
    pytestCheckHook
  ];

  meta = {
    description = "Shared code between key-value-aio and key-value-sync";
    homepage = "https://github.com/strawgate/py-key-value/tree/main/key-value/key-value-shared";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
