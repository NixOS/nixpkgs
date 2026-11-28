{
  lib,
  aws-lc,
  boto3,
  buildPythonPackage,
  cacert,
  django,
  django-async-backend,
  fetchpatch,
  fetchFromGitLab,
  pkg-config,
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
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "django-vpg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rw91j+a7xbcfM/Xk9CR/dFpLJPFlkEFyQfFEpVkTxlI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-18MJRjbK/1R7sHCCbtOO9w2eJ3idfCFJIJvAynQZp6s=";
  };

  patches = [
    # psycopg 3.3.6 changed interval typmod 0xffff to mean unspecified precision
    (fetchpatch {
      url = "https://gitlab.com/glitchtip/django-vpg/-/commit/45878878a722d02af530be90ec054fe1ae99d28f.patch";
      excludes = [ "CHANGELOG.md" ];
      hash = "sha256-p3n0sIoBHrJxOEw1VgJV3mezQGIe1HwHteLwrZc7W/Y=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [ aws-lc ];

  dependencies = [
    django
    psycopg
  ];

  optional-dependencies = {
    async = [ django-async-backend ];
    aws = [ boto3 ];
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
    cacert
    postgresql
    postgresqlTestHook
    pytest-asyncio
    pytest-postgresql
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.async;

  meta = {
    description = "Rust-powered PostgreSQL driver and Django database backend";
    homepage = "https://gitlab.com/glitchtip/django-vpg/";
    changelog = "https://gitlab.com/glitchtip/django-vpg/-/releases/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felbinger
    ];
    broken = lib.versionOlder django.version "6.1";
  };
})
