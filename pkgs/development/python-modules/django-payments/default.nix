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
  setuptools-scm,
  sphinx-rtd-theme,
  stripe,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "django-payments";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-payments";
    rev = "refs/tags/v${version}";
    hash = "sha256-6WPV08CV+rko/tRnsT5GyTGYaJbiIKTvpisfRwizBIo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "django-phonenumber-field[phonenumberslite]" "django-phonenumber-field"
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    django
    django-phonenumber-field
    requests
  ] ++ django-phonenumber-field.optional-dependencies.phonenumbers;

  # require internet connection
  doCheck = false;

  pythonImportsCheck = [ "payments" ];

  passthru.optional-dependencies = {
    all = [
      braintree # suds-community
      mercadopago
      cryptography
      xmltodict
      stripe
    ];
    braintree = [ braintree ];
    cybersource = [
      # suds-community
    ];
    docs = [ sphinx-rtd-theme ];
    mercadopago = [ mercadopago ];
    sagepay = [ cryptography ];
    sofort = [ xmltodict ];
    stripe = [ stripe ];
  };

  meta = with lib; {
    description = "Universal payment handling for Django.";
    homepage = "https://github.com/jazzband/django-payments/";
    changelog = "https://github.com/jazzband/django-payments/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
