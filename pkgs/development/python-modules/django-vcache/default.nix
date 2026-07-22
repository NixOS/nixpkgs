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
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "django-vcache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/LyNJlz3Tx6tgQAwY4vIIsDlL2nCvKM6bna2bXyP5So=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-a9+3k6YTotmj+LBO6OyVd2NUh3hpLwpKXJsX7pBxXNE=";
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
