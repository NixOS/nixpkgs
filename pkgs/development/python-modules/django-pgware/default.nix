{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  psycopg2,
  psycopg,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-pgware";
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Xof";
    repo = "django-pgware";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OvdgqM0W6KPkszNrpeRjmg/powepPyKhfP1OsWaDMSE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    django
  ];

  optional-dependencies = {
    psycopg2 = [
      psycopg2
    ];
    psycopg3 = [
      psycopg
    ];
  };

  pythonImportsCheck = [
    "django_pg_utils"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Useful PostgreSQL-specific Django utiites";
    homepage = "https://github.com/Xof/django-pgware";
    changelog = "https://github.com/Xof/django-pgware/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit-modern
      postgresql
    ];
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
