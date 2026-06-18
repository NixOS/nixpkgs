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
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "django-vcache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7KeSnOJQOb766kYFh6+qeL3csPNuhk63C6NBsoS1dvc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-rQ5nCzWw6AUU9KimNJX3pdnRE4kg86kDTZq0TCBEp8s=";
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
