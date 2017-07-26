{ stdenv, buildPythonPackage, fetchPypi
, certbot, nose, cryptography, pyasn1, pyopenssl, pyRFC3339
, pytz, requests, six, werkzeug, mock, ndg-httpsclient }:

buildPythonPackage rec {
  inherit (certbot) src version;

  pname = "acme";
  name = "${pname}-${version}";

  propagatedBuildInputs = [
    cryptography pyasn1 pyopenssl pyRFC3339 pytz requests six werkzeug mock
    ndg-httpsclient
  ];

  buildInputs = [ nose ];

  postUnpack = "sourceRoot=\${sourceRoot}/acme";
}
