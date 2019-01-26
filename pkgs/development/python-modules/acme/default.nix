{ buildPythonPackage
, certbot
, nose
, cryptography
, pyasn1
, pyopenssl
, pyRFC3339
, josepy
, pytz
, requests
, six
, werkzeug
, mock
, ndg-httpsclient
}:

buildPythonPackage rec {
  inherit (certbot) src version;

  pname = "acme";

  propagatedBuildInputs = [
    cryptography pyasn1 pyopenssl pyRFC3339 pytz requests six werkzeug mock
    ndg-httpsclient josepy
  ];

  checkInputs = [ nose ];

  postUnpack = "sourceRoot=\${sourceRoot}/acme";

  meta = certbot.meta // {
    description = "ACME protocol implementation in Python";
  };
}
