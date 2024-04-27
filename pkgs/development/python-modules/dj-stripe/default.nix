{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  stripe,
  mysqlclient,
  psycopg2,
}:

buildPythonPackage rec {
  pname = "dj-stripe";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dj-stripe";
    repo = "dj-stripe";
    tag = version;
    hash = "sha256-ijTzSid5B79mAi7qUFSGL5+4PfmBStDWayzjW1iwRww=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    stripe
  ];

  passthru.optional-dependencies = {
    mysql = [ mysqlclient ];
    postgres = [ psycopg2 ];
  };

  meta = {
    description = "Stripe Models for Django";
    homepage = "https://github.com/dj-stripe/dj-stripe";
    changelog = "https://github.com/dj-stripe/dj-stripe/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
