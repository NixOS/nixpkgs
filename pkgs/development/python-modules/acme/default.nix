{ buildPythonPackage
, certbot
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
, ndg-httpsclient
}:

buildPythonPackage rec {
  inherit (certbot) src version;

  pname = "acme";

  propagatedBuildInputs = [
    cryptography pyasn1 pyopenssl pyRFC3339 pytz requests requests-toolbelt six
    werkzeug ndg-httpsclient josepy
  ];

  # does not contain any tests
  doCheck = false;
  pythonImportsCheck = [ "acme" ];

<<<<<<< HEAD
  sourceRoot = "${src.name}/${pname}";
=======
  sourceRoot = "source/${pname}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = certbot.meta // {
    description = "ACME protocol implementation in Python";
  };
}
