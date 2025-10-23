{
  lib,
  buildPythonPackage,
  braintree,
  cryptography,
  django,
  django-phonenumber-field,
  fetchFromGitHub,
  mercadopago,
  pythonOlder,
  requests,
  setuptools,
  setuptools-scm,
  stripe,
  suds-community,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "django-payments";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-payments";
    tag = "v${version}";
    hash = "sha256-b8CXMzuTfeF3Q9Ed/Ke2mGGBXYajJYcFkfzkb1lVAIE=";
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

  meta = with lib; {
    description = "Universal payment handling for Django";
    homepage = "https://github.com/jazzband/django-payments/";
    changelog = "https://github.com/jazzband/django-payments/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
