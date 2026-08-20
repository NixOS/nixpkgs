{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitLab,
  hatchling,
  ormsgpack,
  pythonOlder,
  pyzstd,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-vcache";
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "django-vcache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9KsIijeWC97IAD+xlE78UvSSIUp5DbpOdaDRcw8ZxWQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-tpf0r32wNJ/XCmNutoirTobqKgsEX96s4MsI6+p7KlQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    ormsgpack
  ]
  ++ lib.optional (pythonOlder "3.14") pyzstd;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "django_vcache" ];

  # requires valkey sentinel cluster
  doCheck = false;

  meta = {
    description = "Specialized, lightweight Django cache backend for Valkey";
    homepage = "https://gitlab.com/glitchtip/django-vcache/";
    changelog = "https://gitlab.com/glitchtip/django-vcache/-/blob/main/CHANGELOG.md#${
      lib.replaceString "." "" finalAttrs.version
    }";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      defelo
      felbinger
    ];
  };
})
