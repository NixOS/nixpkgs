{
  lib,
  buildPythonPackage,
  croniter,
  django,
  fetchFromGitLab,
  hatchling,
  ormsgpack,
  prometheus-client,
  pythonOlder,
  valkey,
  zstd,
}:

buildPythonPackage rec {
  pname = "django-vcache";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "django-vcache";
    tag = "v${version}";
    hash = "sha256-bOHEw4nl82tFjHiJdmyW0LleKMpjUh8uu4crGp6IsWY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    ormsgpack
    croniter
    valkey
  ]
  ++ valkey.optional-dependencies.libvalkey
  ++ lib.optional (pythonOlder "3.14") zstd;

  optional-dependencies = {
    metrics = [ prometheus-client ];
    valkey = [ valkey ] ++ valkey.optional-dependencies.libvalkey;
  };

  pythonImportsCheck = [ "django_vcache" ];

  # requires valkey sentinel cluster
  doCheck = false;

  meta = {
    description = "Specialized, lightweight Django cache backend for Valkey";
    homepage = "https://gitlab.com/glitchtip/django-vcache/";
    changelog = "https://gitlab.com/glitchtip/django-vcache/-/blob/main/CHANGELOG.md#${
      lib.replaceString "." "" version
    }";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      defelo
      felbinger
    ];
  };
}
