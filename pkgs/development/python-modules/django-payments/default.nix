{
  lib,
  buildPythonPackage,
  braintree,
  cryptography,
  django,
  django-phonenumber-field,
  fetchFromGitHub,
  mercadopago,
  requests,
  setuptools,
  setuptools-scm,
  stripe,
  suds-community,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "django-payments";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-payments";
    tag = "v${version}";
    hash = "sha256-AWWgjLIt3uG5QUVkHLaxWVwqq2dfuPbxUn8VwqMlPwo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    django
    django-phonenumber-field
    requests
  ]
  ++ django-phonenumber-field.optional-dependencies.phonenumberslite;

  # require internet connection
  doCheck = false;

  pythonImportsCheck = [ "payments" ];

  optional-dependencies = {
    braintree = [ braintree ];
    cybersource = [ suds-community ];
    mercadopago = [ mercadopago ];
    sagepay = [ cryptography ];
    sofort = [ xmltodict ];
    stripe = [ stripe ];
  };

  meta = {
    description = "Universal payment handling for Django";
    homepage = "https://github.com/jazzband/django-payments/";
    changelog = "https://github.com/jazzband/django-payments/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
