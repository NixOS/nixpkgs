{
  buildPythonPackage,
  certbot,
  cryptography,
  pyasn1,
  pyopenssl,
  pyrfc3339,
  josepy,
  pytz,
  requests,
  requests-toolbelt,
  six,
  werkzeug,
  ndg-httpsclient,
}:

buildPythonPackage rec {
  inherit (certbot) src version;

  pname = "acme";
  format = "setuptools";

  propagatedBuildInputs = [
    cryptography
    pyasn1
    pyopenssl
    pyrfc3339
    pytz
    requests
    requests-toolbelt
    six
    werkzeug
    ndg-httpsclient
    josepy
  ];

  # does not contain any tests
  doCheck = false;
  pythonImportsCheck = [ "acme" ];

  sourceRoot = "${src.name}/${pname}";

  meta = certbot.meta // {
    description = "ACME protocol implementation in Python";
  };
}
