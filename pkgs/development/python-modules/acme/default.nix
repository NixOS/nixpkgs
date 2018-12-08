{ buildPythonPackage
, certbot
, nose
, pytest
, cryptography
, pyasn1
, pyopenssl
, pyRFC3339
, josepy
, pytz
, requests
, requests-toolbelt
, six
, werkzeug
, mock
, ndg-httpsclient
}:

buildPythonPackage rec {
  inherit (certbot) src version;

  pname = "acme";

  propagatedBuildInputs = [
    cryptography pyasn1 pyopenssl pyRFC3339 pytz requests requests-toolbelt six
    werkzeug mock ndg-httpsclient josepy
  ];

  checkInputs = [ nose pytest ];

  postUnpack = "sourceRoot=\${sourceRoot}/acme";

  meta = certbot.meta // {
    description = "ACME protocol implementation in Python";
  };
}
