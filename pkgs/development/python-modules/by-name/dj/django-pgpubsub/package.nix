{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  poetry-core,
  django,
  django-pgtrigger,
}:

buildPythonPackage rec {
  pname = "django-pgpubsub";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PaulGilmartin";
    repo = "django-pgpubsub";
    tag = version;
    hash = "sha256-Gl6NfBaoj3WKLHwJElbb27CYVQ83s3f86NUOZE7lHCk=";
  };

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace 'poetry.masonry.api' 'poetry.core.masonry.api' \
    --replace 'poetry>=1.1.13' 'poetry-core>=1.0.0' \
  '';

  build-system = [ poetry-core ];

  dependencies = [
    django
    django-pgtrigger
  ];

  pythonImportsCheck = [ "pgpubsub" ];

  meta = {
    description = "Lightweight background tasks using Django Channels and PostgreSQL NOTIFY/LISTEN";
    homepage = "https://github.com/PaulGilmartin/django-pgpubsub";
    changelog = "https://github.com/PaulGilmartin/django-pgpubsub/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ raitobezarius ];
  };
}
