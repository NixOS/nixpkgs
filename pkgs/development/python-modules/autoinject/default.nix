{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  python,
  pythonOlder,
  runCommand,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "autoinject";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "turnbullerin";
    repo = "autoinject";
    # Upstream does not tag releases.
    rev = "9d29a307ce1ef331e8ded5f8161d0ed2c29cf67e";
    hash = "sha256-uCUMHNaSwl3/6MeIc1Ztz/2zNTxQQlAbH+GZKm3fynw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autoinject" ];

  passthru.tests.integration =
    runCommand "${finalAttrs.pname}-integration-test"
      {
        nativeBuildInputs = [
          (python.withPackages (_: [ finalAttrs.finalPackage ]))
        ];
      }
      ''
        python - <<'PY'
        from autoinject import InjectionManager

        injector = InjectionManager()

        @injector.injectable
        class Service:
            value = "injected"

        class Client:
            @injector.inject
            def __init__(self, service: Service):
                self.service = service

        assert Client().service.value == "injected"
        PY

        touch "$out"
      '';

  meta = {
    changelog = "https://github.com/turnbullerin/autoinject/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Dependency injection framework for Python";
    homepage = "https://github.com/turnbullerin/autoinject";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lostmsu ];
  };
})
