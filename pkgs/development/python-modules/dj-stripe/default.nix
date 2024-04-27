{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, django
, stripe
, mysqlclient
, psycopg2
}:

buildPythonPackage rec {
  pname = "dj-stripe";
  version = "2.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dj-stripe";
    repo = "dj-stripe";
    rev = version;
    hash = "sha256-uBJ1qaUADOPaZBDC+qlBLOz1qQVMT3JEN78eW4LbDbQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'stripe = ">=2.48.0,<5.0.0"' 'stripe = "*"'
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    django
    stripe
  ];

  passthru.optional-dependencies = {
    mysql = [
      mysqlclient
    ];
    postgres = [
      psycopg2
    ];
  };

  meta = {
    description = "Dj-stripe automatically syncs your Stripe Data to your local database as pre-implemented Django Models allowing you to use the Django ORM, in your code, to work with the data making it easier and faster";
    homepage = "https://github.com/dj-stripe/dj-stripe/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
