{
  lib,
  buildPythonPackage,
  django,
  django-async-backend,
  fetchFromGitLab,
  postgresql,
  postgresqlTestHook,
  psycopg,
  pytest-asyncio,
  pytest-postgresql,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-vpg";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "django-vpg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OTmiTuEITDXvjfwfMsDsFGB+/RitpixPZkaQsgTccw8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-OogYNLzPk7Dxkzkevkjsgrl8fRb1TE9wEqhVIRkhknU=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    django
    psycopg
  ];

  optional-dependencies = {
    async = [ django-async-backend ];
  };

  pythonImportsCheck = [ "django_vpg" ];

  env = {
    VPG_TEST_DSN = "postgres://postgres@127.0.0.1:5432/postgres";
  };

  preCheck = ''
    rm -r django_vpg
  '';

  postgresqlEnableTCP = 1;

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
    pytest-asyncio
    pytest-postgresql
    pytestCheckHook
  ]
  ++ lib.optionals (
    lib.versions.major django.version == "6"
  ) finalAttrs.passthru.optional-dependencies.async;

  meta = {
    description = "Rust-powered PostgreSQL driver and Django database backend";
    homepage = "https://gitlab.com/glitchtip/django-vpg/";
    changelog = "https://gitlab.com/glitchtip/django-vpg/-/releases/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      defelo
      felbinger
    ];
  };
})
