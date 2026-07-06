{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-key-value-shared-test";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strawgate";
    repo = "py-key-value";
    tag = finalAttrs.version;
    hash = "sha256-4ji+GzJTv1QnC5n/OaL9vR65j8BQmJsVGGnjjuulDiU=";
  };

  sourceRoot = "${finalAttrs.src.name}/key-value/key-value-shared-test";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "uv_build>=0.8.2,<0.9.0" \
        "uv_build"
  '';

  build-system = [
    uv-build
  ];

  pythonImportsCheck = [ "key_value.shared_test" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Utils for key-value-shared";
    homepage = "https://github.com/strawgate/py-key-value/tree/main/key-value/key-value-shared-test";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
